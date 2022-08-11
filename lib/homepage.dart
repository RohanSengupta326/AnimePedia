import 'package:flutter/material.dart';
import 'package:series/screens/searchPage.dart';

import './api/seriesdata.dart';
import './screens/seriesView.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'errorPage.dart';

import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(SeriesData());
  String _error = '';
  int i = 1;
  int cols = GetPlatform.isDesktop ? 4 : 2;
  ScrollController scrollController = ScrollController();
  RxBool showButton = false.obs;
  // to show, go to top button or not

  void fetch([bool? onInternetGone]) {
    // if trying again after internet gone, start from first page
    if (onInternetGone != null && onInternetGone == true) {
      i = 1;
    }
    // when trying to fetch again, make error empty
    _error = '';
    // to show lazy loader at the bottom
    controller.fetchData(i.toString()).catchError((errorMsg) {
      _error = errorMsg;
    });
  }

  @override
  void initState() {
    fetch();
    // first fetch on app start

    // when scrolled down , then show button to come up
    scrollController.addListener(() {
      double showOffSet = 10.0;

      if (scrollController.offset > showOffSet) {
        showButton.value = true;
      } else {
        showButton.value = false;
      }
    });
    super.initState();
  }

  Widget getBody() {
    return controller.isLoading.value
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
        : _error.isNotEmpty
            ? ErrorPage(fetch, _error)
            // to show when data cant get loaded
            : LazyLoadScrollView(
                isLoading: controller.isLoading2.value,
                onEndOfPage: () {
                  i++;
                  return fetch();
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.pageRefresh();
                    i = 1;
                    return fetch();
                  },
                  child: GridView.builder(
                    controller: scrollController,
                    // to get scrolling position and go to top when app name
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: cols),
                    itemBuilder: (ctx, index) {
                      if (index < controller.items.length) {
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
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );
                      }
                    },
                    itemCount: controller.items.length + 1,
                  ),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(SearchPage());
            },
            icon: const Icon(Icons.search),
          ),
        ],
        backgroundColor: Colors.amber,
        title: TextButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: const Text(
            'AnimePedia',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: Obx(
        () {
          return getBody();
        },
      ),
      floatingActionButton: Obx(() {
        // when scrolled down a bit only then button shows
        return AnimatedOpacity(
          opacity: showButton.value ? 1 : 0,
          duration: const Duration(seconds: 1),
          child: FloatingActionButton(
            onPressed: () {
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            },
            backgroundColor: Colors.amber,
            elevation: 16,
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
