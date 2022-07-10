import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/series.dart';
import 'dart:convert';
import 'package:get/get.dart';
import './apiKey.dart';

class SeriesData extends GetxController {
  var internetError = '';
  List<Series> _items = [];
  bool isError = false;
  bool isMorePageFetchError = false;

  List<Series> get items {
    return [..._items];
  }

  Future<void> fetchData(String pageNo) async {
    isError = false;
    var apiCall = ApiKey().urL;

    String urL = '$apiCall$pageNo'; // your api here

    var url = Uri.parse(
      urL,
    );
    try {
      final response = await http.get(url);
      print(response.statusCode);

      final extractedData = json.decode(response.body)['data']; // list

      // Map<String, List<Map<String, dynamic>>>
      if (extractedData == null) {
        // Get.snackbar('Error', 'Could not load data');
        return;
      }

      for (int i = 0; i < extractedData.length; i++) {
        final Map<String, dynamic> favoriteResponse = extractedData[i];
        // first map
        _items.add(
          Series(
            image: favoriteResponse['images']['jpg']['image_url'],
            title: favoriteResponse['title'],
          ),
        );
      }
    } on SocketException catch (error) {
      // no internet
      double.parse(pageNo) > 1 ? isMorePageFetchError = true : isError = true;
      internetError = error.message;
      return;
    } catch (error) {
      // print('caught error : $error');

      isError = true;
      return;
    }
  }

  refresh() {
    _items = [];
  }
}
