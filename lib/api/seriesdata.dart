import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/series.dart';
import '../models/userData.dart';
import './apiKey.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SeriesData extends GetxController {
  RxBool isFavAdding = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool isLoadingAuth = false.obs;
  RxBool isLoadingUserData = false.obs;
  RxBool isSearchLoading = false.obs;
  RxBool isSaveUserDataLoading = false.obs;
  int allAnimeCount = 10;
  int searchResultCount = 10;
  final _auth = FirebaseAuth.instance;
  List<UserData> currentUserData = [
    UserData('', ''),
  ];
  List<Series> _items = [];
  List<Series> get items {
    return [..._items];
  }

  List<Series> _favouritesList = [];
  List<Series> get favourites {
    return [..._favouritesList];
  }

  List<Series> _searchResult = [];
  List<Series> get searchResult {
    return [..._searchResult];
  }

  Future<void> fetchData(String pageNo) async {
    // when fetching from beginning make sure list is empty so prev things dont come
    if (pageNo == '1') {
      _items = [];
    }

    // at one call we fetch 10 items, so if this count < 10, end of list, fetch no more
    if (allAnimeCount < 10) {
      return;
    }

    var apiCall = ApiKey().urL;

    String urL = '$apiCall$pageNo'; // your api here

    var url = Uri.parse(
      urL,
    );
    try {
      if (pageNo == '1') {
        isLoading.value = true;
      } else {
        isLoading2.value = true;
      }

      final response = await http.get(url);
      // log(response.statusCode.toString());

      final Map<String, dynamic>? extractedData =
          json.decode(response.body); // list

      if (extractedData == null) {
        // Get.snackbar('Error', 'Could not load data');
        return;
      }

      // how many items got fetched , if none, return
      allAnimeCount = extractedData['data'].length;
      if (allAnimeCount == 0) {
        return;
      }

      for (int i = 0; i < extractedData['data'].length; i++) {
        final Map<String, dynamic> recievedData = extractedData['data'][i];
        // first map
        _items.add(
          Series(
            image: recievedData['images']['jpg']['image_url'],
            title: recievedData['title'],
            trailerUrl: recievedData['trailer']['url'],
            titleJapanese: recievedData['title_japanese'],
            synopsis: recievedData['synopsis'],
            status: recievedData['status'],
            episodes: recievedData['episodes'],
            episodeLength: recievedData['duration'],
            rating: recievedData['rating'],
            startDate: recievedData['aired']['from'],
            endDate: recievedData['aired']['to'],
          ),
        );
      }

      isLoading.value = false;
      isLoading2.value = false;
      return;
    } on SocketException catch (_) {
      // no internet
      isLoading.value = false;

      isLoading2.value = false;
      throw 'Could not connect to the internet!';
    } catch (_) {
      // print('caught error : $error');
      isLoading.value = false;
      isLoading2.value = false;
      throw 'Something Went Wrong! Please try again later!';
    }
  }

  // FETCH DATA ACCORDING TO USER SEARCH
  Future<void> fetchUserSearch(String animeName) async {
    // before getting new suggestions delete prev suggestions
    _searchResult.clear();

    var apiCall = ApiKey().animeSearchUrl;

    String urL = '$apiCall$animeName&limit=10';

    var url = Uri.parse(
      urL,
    );
    try {
      isSearchLoading.value = true;
      final response = await http.get(url);

      final Map<String, dynamic>? extractedData =
          json.decode(response.body); // list

      if (extractedData == null) {
        return;
      }

      // how many items got fetched , if none, return
      searchResultCount = extractedData['data'].length;
      if (allAnimeCount == 0) {
        return;
      }

      for (int i = 0; i < extractedData['data'].length; i++) {
        final Map<String, dynamic> recievedData = extractedData['data'][i];
        // first map
        _searchResult.add(
          Series(
            image: recievedData['images']['jpg']['image_url'],
            title: recievedData['title'],
            trailerUrl: recievedData['trailer']['url'],
            titleJapanese: recievedData['title_japanese'],
            synopsis: recievedData['synopsis'],
            status: recievedData['status'],
            episodes: recievedData['episodes'],
            episodeLength: recievedData['duration'],
            rating: recievedData['rating'],
            startDate: recievedData['aired']['from'],
            endDate: recievedData['aired']['to'],
          ),
        );
      }

      isSearchLoading.value = false;
      return;
    } on SocketException catch (_) {
      // no internet
      isSearchLoading.value = false;
      throw 'Could not connect to the internet!';
    } catch (_) {
      // print('caught error : $error');
      isSearchLoading.value = false;
      throw 'Something Went Wrong! Please try again later!';
    }
  }

  void pageRefresh() {
    _items.clear();
  }

  Future<void> authUser(String email, String username, String password,
      bool isLogin, XFile? image) async {
    UserCredential userCredential;

    try {
      isLoadingAuth.value = true;

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      if (userCredential.user == null) {
        throw 'something went wrong ! Please try again later';
      }

      if (!isLogin) {
        final refPath = FirebaseStorage.instance
            .ref()
            .child('user-image')
            .child(userCredential.user!.uid + '.jpg');

        await refPath.putFile(
          File(image!.path),
        );

        final dpUrl = await refPath.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'dpUrl': dpUrl,
          },
        );
      }

      isLoadingAuth.value = false;
    } on FirebaseAuthException catch (error) {
      isLoadingAuth.value = false;
      if (error.code == 'email-already-in-use') {
        throw 'Email already exists.\nLogIn Instead.';
      }
      if (error.code == 'invalid-email' ||
          error.code == 'invalid-email-verified') {
        throw 'Email is not valid!';
      }
      if (error.code == 'user-not-found') {
        throw 'User not found!';
      }
      if (error.code == 'wrong-password') {
        throw 'Password is incorrect!';
      }
      throw 'Something  Went Wrong!\nPlease check your email/password!';
    } catch (error) {
      isLoadingAuth.value = false;
      throw 'Something went wrong';
    }
  }

  Future<void> fetchUserData() async {
    currentUserData = [UserData('', '')];
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      isLoadingUserData.value = true;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      currentUserData = [
        UserData(
          userData['username'],
          userData['dpUrl'],
        ),
      ];
      isLoadingUserData.value = false;
    } catch (err) {
      isLoadingUserData.value = false;
      throw 'Could not fetch user data';
    }
  }

  Future<void> saveNewUserData(String username, XFile? image) async {
    try {
      isSaveUserDataLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final refPath = FirebaseStorage.instance
          .ref()
          .child('user-image')
          .child(userId + '.jpg');

      await refPath.putFile(
        File(image!.path),
      );

      final dpUrl = await refPath.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          'username': username,
          'dpUrl': dpUrl,
        },
      );
      isSaveUserDataLoading.value = false;
    } on FirebaseAuthException {
      isSaveUserDataLoading.value = false;
      throw 'Could not save data at the moment, Please try again later';
    } catch (err) {
      isSaveUserDataLoading.value = false;
      throw 'Could not save data at the moment, Please try again later';
    }
  }

  Future<void> updateFavourites(
    final image,
    final title,
    final episodeLength,
    final episodes,
    final rating,
    final startDate,
    final endDate,
    final status,
    final synopsis,
    final titleJapanese,
    final trailerUrl,
    bool isFavourite,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      isFavAdding.value = true;
      if (!isFavourite) {
        await FirebaseFirestore.instance
            .collection('user-favourite')
            .doc(userId)
            .collection('items')
            .doc(title)
            .set(
          {
            'image': image,
            'title': title,
            'episodeLength': episodeLength,
            'episodes': episodes,
            'rating': rating,
            'startDate': startDate,
            'endDate': endDate,
            'status': status,
            'synopsis': synopsis,
            'titleJapanese': titleJapanese,
            'trailerUrl': trailerUrl,
          },
        ).then((value) {
          _favouritesList.add(
            Series(
                endDate: endDate,
                episodeLength: episodeLength,
                episodes: episodes,
                image: image,
                rating: rating,
                startDate: startDate,
                status: status,
                synopsis: synopsis,
                title: title,
                titleJapanese: titleJapanese,
                trailerUrl: trailerUrl),
          );
        });
        isFavAdding.value = false;
      } else {
        await FirebaseFirestore.instance
            .collection('user-favourite')
            .doc(userId)
            .collection('items')
            .doc(title)
            .delete()
            .then((value) {
          _favouritesList.removeAt(
            _favouritesList.indexWhere((element) => element.title == title),
          );
        });
        isFavAdding.value = false;
      }
    } on FirebaseAuthException {
      isFavAdding.value = false;
      throw 'Could not edit favourites list';
    } catch (error) {
      isFavAdding.value = false;
      throw 'Something went wrong!, please try again later';
    }
  }

  Future<void> fetchUserFavouriteList() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      isFavAdding.value = true;
      final userData = await FirebaseFirestore.instance
          .collection('user-favourite')
          .doc(userId)
          .collection('items')
          .get();

      _favouritesList = List.from(
        userData.docs.map(
          (e) => Series(
              endDate: e.data()['endDate'],
              episodeLength: e.data()['episodeLength'],
              episodes: e.data()['episodes'],
              image: e.data()['image'],
              rating: e.data()['rating'],
              startDate: e.data()['startDate'],
              status: e.data()['status'],
              synopsis: e.data()['synopsis'],
              title: e.data()['title'],
              titleJapanese: e.data()['titleJapanese'],
              trailerUrl: e.data()['trailerUrl']),
        ),
      );

      isFavAdding.value = false;
    } catch (err) {
      isFavAdding.value = false;
      throw 'Could not fetch user favourites list';
    }
  }

  Future<void> logOut() async {
    _auth.signOut();
    currentUserData = [
      UserData('', ''),
    ];
  }
}
