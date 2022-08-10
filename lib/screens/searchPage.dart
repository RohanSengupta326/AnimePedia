import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/errorPage.dart';
import 'package:series/screens/seriesView.dart';

class SearchPage extends StatelessWidget {
  final SeriesData userSearchController = Get.find();
  TextEditingController searchController = TextEditingController();
  RxString userQuery = ''.obs;
  final SeriesData controller = Get.find();
  RxBool isLoadingSearch = false.obs;
  String _error = '';

  searchAnime(String? query) {
    /* userSearchController.searchResult.clear();

    if (query == null) {
      return;
    }
    userQuery.value = query;
    userSearchController.searchResult = controller.items.where((element) {
      final title = element.title.toString().toLowerCase();
      final userSearch = query.toLowerCase();

      return title.contains(userSearch);
    }).toList(); */

    // print('SEARCH RESULT -- ${userSearchController.searchResult.length}');
    // print(userSearchController.searchResult.isNotEmpty
    //     ? userSearchController.searchResult[userSearchController.searchResult.length - 1].title
    //     : '');

    isLoadingSearch.value = true;
    userSearchController.fetchUserSearch(query ?? '').catchError((errorMsg) {
      _error = errorMsg.toString();
    });
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
                onSubmitted: searchAnime,
              ),
            ),
            Expanded(
              child: Obx(() {
                return userSearchController.isSearchLoading.value
                    ? Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Column(
                            children: const [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'wait a moment..',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : userSearchController.searchResult.isEmpty
                        ? const Text('Search Something!')
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
                                image: userSearchController
                                    .searchResult[index].image,
                                title: userSearchController
                                    .searchResult[index].title,
                                endDate: userSearchController
                                    .searchResult[index].endDate,
                                episodeLength: userSearchController
                                    .searchResult[index].episodeLength,
                                episodes: userSearchController
                                    .searchResult[index].episodes,
                                rating: userSearchController
                                    .searchResult[index].rating,
                                startDate: userSearchController
                                    .searchResult[index].startDate,
                                status: userSearchController
                                    .searchResult[index].status,
                                synopsis: userSearchController
                                    .searchResult[index].synopsis,
                                titleJapanese: userSearchController
                                    .searchResult[index].titleJapanese,
                                trailerUrl: userSearchController
                                    .searchResult[index].trailerUrl,
                              );
                            },
                            itemCount: userSearchController.searchResult.length,
                          );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
