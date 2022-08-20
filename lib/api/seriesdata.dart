import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/series.dart';
import './apiKey.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SeriesData extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool isLoadingAuth = false.obs;
  RxBool isSearchLoading = false.obs;
  int allAnimeCount = 10;
  int searchResultCount = 10;
  final _auth = FirebaseAuth.instance;

  List<Series> _items = [];
  List<Series> get items {
    return [..._items];
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
      print('starting');

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

      final refPath = FirebaseStorage.instance
          .ref()
          .child('user-image')
          .child(userCredential.user!.uid + '.jpg');

      await refPath.putFile(
        File(image == null ? 'assets/images/userdp.png' : image.path),
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

      isLoadingAuth.value = false;
    } on PlatformException catch (error) {
      isLoadingAuth.value = false;
      // throw 'Something Went Wrong';
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE' && !isLogin) {
        throw 'Email already exists';
      }
      if (error.code == "ERROR_INVALID_EMAIL") {
        throw 'Email is not valid/doesn\'nt exist';
      }
    } catch (error) {
      isLoadingAuth.value = false;
      throw 'Something  Went Wrong';
    }
  }
}
