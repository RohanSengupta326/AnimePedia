import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import '../models/series.dart';
import './apiKey.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SeriesData extends GetxController {
  List<Series> _items = [];
  List<Series> get items {
    return [..._items];
  }

  Future<void> fetchData(String pageNo) async {
    var apiCall = ApiKey().urL;

    String urL = '$apiCall$pageNo'; // your api here

    var url = Uri.parse(
      urL,
    );
    try {
      final response = await http.get(url);
      log(response.statusCode.toString());

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
    } on SocketException catch (_) {
      // no internet
      throw 'Could not connect to the internet';
    } catch (_) {
      // print('caught error : $error');
      throw 'Something Went Wrong!\nPlease try again later!';
    }
  }

  void pageRefresh() {
    _items = [];
  }
}
