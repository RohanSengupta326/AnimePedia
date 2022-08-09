import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/models/series.dart';
import 'package:series/screens/seriesView.dart';

class SearchPage extends StatelessWidget {
  final SeriesData controller = Get.find();
  List<Series> searchResult = [];

  searchAnime(String? query) {
    searchResult = controller.items.where((element) {
      return element.title == query;
    }).toList();

    print(searchResult.length);
    print(searchResult[0].title);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
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
                onSubmitted: searchAnime(searchController.text),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2),
                itemBuilder: (ctx, index) {
                  return SeriesView(
                    image: controller.items[index].image,
                    title: controller.items[index].title,
                    endDate: controller.items[index].endDate,
                    episodeLength: controller.items[index].episodeLength,
                    episodes: controller.items[index].episodes,
                    rating: controller.items[index].rating,
                    startDate: controller.items[index].startDate,
                    status: controller.items[index].status,
                    synopsis: controller.items[index].synopsis,
                    titleJapanese: controller.items[index].titleJapanese,
                    trailerUrl: controller.items[index].trailerUrl,
                  );
                },
                itemCount: searchResult.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
