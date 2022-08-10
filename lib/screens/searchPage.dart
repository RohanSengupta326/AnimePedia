import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/models/series.dart';
import 'package:series/screens/seriesView.dart';

class SearchPage extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  RxString userQuery = ''.obs;
  final SeriesData controller = Get.find();
  List<Series> searchResult = [];

  searchAnime(String? query) {
    searchResult.clear();

    if (query == null) {
      return;
    }
    userQuery.value = query;
    searchResult = controller.items.where((element) {
      final title = element.title.toString().toLowerCase();
      final userSearch = query.toLowerCase();

      return title.contains(userSearch);
    }).toList();

    print('SEARCH RESULT -- ${searchResult.length}');
    print(searchResult.isNotEmpty
        ? searchResult[searchResult.length - 1].title
        : '');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                scrollPadding: const EdgeInsets.all(8),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  hintText: 'Search',
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                cursorColor: Colors.white,
                onChanged: searchAnime,
              ),
            ),
            Expanded(
              child: Obx(() {
                return userQuery.value.isEmpty
                    ? const Center()
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 2 / 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                crossAxisCount: 2),
                        itemBuilder: (ctx, index) {
                          return SeriesView(
                            image: searchResult[index].image,
                            title: searchResult[index].title,
                            endDate: searchResult[index].endDate,
                            episodeLength: searchResult[index].episodeLength,
                            episodes: searchResult[index].episodes,
                            rating: searchResult[index].rating,
                            startDate: searchResult[index].startDate,
                            status: searchResult[index].status,
                            synopsis: searchResult[index].synopsis,
                            titleJapanese: searchResult[index].titleJapanese,
                            trailerUrl: searchResult[index].trailerUrl,
                          );
                        },
                        itemCount: searchResult.length,
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
