import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/screens/seriesView.dart';
import 'package:series/widgets/emptySearchPage.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SeriesData userSearchController = Get.find();
  TextEditingController searchController = TextEditingController();
  String _error = '';
  Timer? debouncer;
  // to set timer for server each request

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  // if user types fast , many server requests gets sent on top of another, so the recieved list is not appropriate
  // and creates pressure on server
  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
    // creates timer of 500 milliseconds
  }) {
    if (debouncer != null) {
      // before 500 milliseconds server request wont be sent, so if another prev
      // timer is not yet null means prev server request is not completed yet, so cancel prev request before sending
      // and set new timer for next request
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

//  sends server request according to user search
  searchAnime(String query) {
    _error = '';
    // empties the error variable before every server request else it will store the previous error and show error
    // even if theres none
    debounce(() {
      userSearchController.fetchUserSearch(query).catchError((errorMsg) {
        _error = errorMsg.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                // on changing input by user everytime, this function is called
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
                              SizedBox(
                                child: Text(
                                  'wait a moment..',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : _error.isNotEmpty
                        // if no error
                        ? Text(_error)
                        : userSearchController.searchResult.isEmpty &&
                                searchController.text.isEmpty
                            // no input has been typed by user
                            ? SingleChildScrollView(
                                child: EmptySearchPage(
                                    'Search your favourite Anime!'))
                            : userSearchController.searchResult.isEmpty &&
                                    searchController.text.isNotEmpty
                                // couldnt find typed content by user
                                ? const Text('Sorry! Could not find any result')
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
                                    itemCount: userSearchController
                                        .searchResult.length,
                                  );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
