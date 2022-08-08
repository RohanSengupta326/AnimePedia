import 'package:flutter/material.dart';

import './api/seriesdata.dart';
import './screens/seriesView.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'errorPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(SeriesData());
  // RxBool _isLoading = false.obs;
  // when app starts, loader at center
  // RxBool _isLoading2 = false.obs;
  // loader when fetching more data at the bottom

  String _error = '';
  int i = 1;
  int cols = GetPlatform.isDesktop ? 4 : 2;

  void fetch([bool? onInternetGone]) {
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
    super.initState();
  }

  Widget getBody() {
    return controller.isLoading.value
        ? Center(
            child: Container(
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
            : RefreshIndicator(
                onRefresh: () async {
                  controller.pageRefresh();
                  i = 1;
                  return fetch();
                },
                child: LazyLoadScrollView(
                  isLoading: controller.isLoading2.value,
                  onEndOfPage: () {
                    i++;
                    return fetch();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: cols),
                    itemBuilder: (ctx, index) {
                      if (index < controller.items.length) {
                        return SeriesView(controller.items[index].image,
                            controller.items[index].title);
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
      appBar: AppBar(title: const Text('AnimePedia')),
      body: Obx(
        () {
          return getBody();
        },
      ),
    );
  }
}
