import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:series/screens/noFavouritesScreen.dart';

import 'package:series/screens/seriesView.dart';

import '../api/seriesdata.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  ScrollController scrollController = ScrollController();
  // bool isFavLoaded = false;
  final SeriesData controller = Get.find();

  void getUserFavouriteList() {
    // if (isFavLoaded) {
    //   return;
    // }
    controller.fetchUserFavouriteList().then((value) {
      // isFavLoaded = true;
    }).catchError((er) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  er.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    shadowColor: MaterialStatePropertyAll(Colors.amber),
                    elevation: MaterialStatePropertyAll(8),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(Colors.amber),
                  ),
                  child: Text('Ok!'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  void initState() {
    getUserFavouriteList();

    super.initState();
  }

  Widget getBody() {
    return Obx(() {
      return controller.isFavAdding.value
          ? Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : controller.favourites.isEmpty
              ? Center(
                  child: NoFavouritesScreen(),
                )
              : GridView.builder(
                  controller: scrollController,
                  // to get scrolling position and go to top when app name
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 2),
                  itemBuilder: (ctx, index) {
                    return SeriesView(
                      image: controller.favourites[index].image,
                      title: controller.favourites[index].title,
                      endDate: controller.favourites[index].endDate,
                      episodeLength: controller.favourites[index].episodeLength,
                      episodes: controller.favourites[index].episodes,
                      rating: controller.favourites[index].rating,
                      startDate: controller.favourites[index].startDate,
                      status: controller.favourites[index].status,
                      synopsis: controller.favourites[index].synopsis,
                      titleJapanese: controller.favourites[index].titleJapanese,
                      trailerUrl: controller.favourites[index].trailerUrl,
                    );
                  },
                  itemCount: controller.favourites.length,
                );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.amber,
        title: TextButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn);
          },
          child: const Text(
            'Your Favourite Animes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.amber,
        onRefresh: () async {
          // isFavLoaded = false;
          getUserFavouriteList();
        },
        child: getBody(),
      ),
    );
  }
}
