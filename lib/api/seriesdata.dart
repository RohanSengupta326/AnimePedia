import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import '../models/series.dart';
import 'dart:convert';
import 'package:get/get.dart';

class SeriesData extends GetxController {
  List<Series> _items = [];

  List<Series> get items {
    return [..._items];
  }

  Future<void> fetchData(String pageNo) async {
    String urL = 'https://api.jikan.moe/v4/top/anime?limit=10&page=$pageNo';
    var url = Uri.parse(
      urL,
    );
    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body)['data']; // list

        // Map<String, List<Map<String, dynamic>>>
        if (extractedData == null) {
          Get.snackbar('Error', 'Could not load data');
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
      } else if (response.statusCode > 400) {
        Get.snackbar('error', 'some error occurred');
      }
    } catch (error) {
      throw (error);
    }
  }

  refresh() {
    _items = [];
  }
}
