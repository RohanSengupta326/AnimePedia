import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:series/screens/seriesView.dart';

import '../api/seriesdata.dart';
import '../widgets/appDrawer.dart';

class FavouritesScreen extends StatelessWidget {
  ScrollController scrollController = ScrollController();
  final SeriesData controller = Get.find();

  Widget getBody() {
    return GridView.builder(
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
  }

  @override
  Widget build(BuildContext context) {
    RxInt favListSize = controller.favourites.length.obs;
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
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: Obx(
        () {
          return favListSize.value <= 0
              ? Center(child: Text('No favourites!'))
              : getBody();
        },
      ),
    );
  }
}
