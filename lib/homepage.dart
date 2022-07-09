import 'package:flutter/material.dart';

import './api/seriesdata.dart';
import './screens/seriesView.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  final controller = Get.put(SeriesData());

  var _isLoading = false.obs;
  var _isLoading2 = false.obs;
  var i = 1;

  int cols = GetPlatform.isDesktop ? 4 : 2;

  // _fetchAgain() {
  //   _isLoading2.value = true;
  //   controller.fetchData((++i).toString()).then((_) {
  //     _isLoading2.value = false;
  //   });
  // }
  var _error;
  void fetch() {
    if (i == 1) {
      _isLoading.value = true;
      // to show first screen loader in the center
    }
    _isLoading2.value = true;
    // to show lazy loader at the bottom
    try {
      controller.fetchData(i.toString()).then(
        (_) {
          if (i == 1) {
            _isLoading.value = false;
          }
          _isLoading2.value = false;
        },
      );
    } catch (error) {
      _error = error.toString();
      Get.snackbar('error', 'An error occurred');
    }
  }

  @override
  void initState() {
    fetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        i++;
        fetch();
        // screen bottom to call fetch function again to fetch second page data
        // print('reached');
      }
    });

    super.initState();
  }

  Widget getBody() {
    return _isLoading.value
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
                  'wait a moment',
                  style: TextStyle(
                    color: Colors.white38,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ))
        : LazyLoadScrollView(
            isLoading: _isLoading2.value,
            onEndOfPage: () {
              i++;
              return fetch();
            },
            child: RefreshIndicator(
              onRefresh: () async {
                controller.refresh();
                i = 1;
                return fetch();
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: cols),
                itemBuilder: (ctx, index) {
                  if (index + 1 == controller.items.length) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  if (index + 2 == controller.items.length) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  return SeriesView(controller.items[index].image,
                      controller.items[index].title);
                },
                itemCount: controller.items.length,
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
