import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:series/api/seriesdata.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailPage extends StatelessWidget {
  final image;
  final title;
  final episodeLength;
  final episodes;
  final rating;
  final startDate;
  final endDate;
  final status;
  final synopsis;
  final titleJapanese;
  final trailerUrl;
  final SeriesData controller = Get.find();
  RxBool isData = false.obs;

  AnimeDetailPage(
      {this.image,
      this.title,
      this.episodeLength,
      this.episodes,
      this.rating,
      this.startDate,
      this.endDate,
      this.status,
      this.synopsis,
      this.titleJapanese,
      this.trailerUrl}) {}

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(trailerUrl ?? '');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      // to open in youtube
    )) {
      throw 'Could not launch $url';
    }
  }

  void updateFav(BuildContext context) {
    controller
        .updateFavourites(
            image,
            title,
            episodeLength,
            episodes,
            rating,
            startDate,
            endDate,
            status,
            synopsis,
            titleJapanese,
            trailerUrl,
            isData.value ? false : true)
        .then((_) {
      isData.value = (controller.favourites
              .indexWhere((element) => element.title == title) <
          0);
    }).catchError((err) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  err.toString(),
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
  Widget build(BuildContext context) {
    isData.value =
        (controller.favourites.indexWhere((element) => element.title == title) <
            0);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.amber,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            right: 20,
            left: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 250,
                      width: 150,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 250,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: title ?? '',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Rating : ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: rating == null
                                          ? ''
                                          : rating.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Episodes : ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: episodes == null
                                          ? ''
                                          : episodes.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Episode Length : ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: episodeLength == null
                                          ? ''
                                          : episodeLength.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Status : ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: status ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                                child: Row(
                              children: [
                                const Text(
                                  'Trailer : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                GestureDetector(
                                  onTap: () => _launchUrl(),
                                  child: Text(
                                    trailerUrl == null ? '' : 'here',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Divider(),
              Obx(() {
                return controller.isFavAdding.value
                    ? Container(
                        margin: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: CupertinoActivityIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          child: Row(
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  updateFav(context);
                                },
                                icon: Icon(
                                  isData.value ? Icons.star_border : Icons.star,
                                  color: Colors.amber,
                                ),
                                label: Text(
                                  'Favourite',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              }),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'Japanese Name : ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                      children: <TextSpan>[
                        TextSpan(
                          text: titleJapanese ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'Start Date : ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                      children: <TextSpan>[
                        TextSpan(
                          text: startDate == null
                              ? ''
                              : DateFormat('dd MMMM, yyy')
                                  .format(DateTime.parse(startDate)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'End Date : ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                      children: <TextSpan>[
                        TextSpan(
                          text: status == null
                              ? ''
                              : status == 'Finished Airing'
                                  ? endDate == null
                                      ? ''
                                      : DateFormat('dd MMMM, yyy')
                                          .format(DateTime.parse(endDate))
                                  : 'Ongoing',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      text: 'Story Line : ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                      children: <TextSpan>[
                        TextSpan(
                          text: synopsis ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
