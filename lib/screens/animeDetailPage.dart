import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:series/api/seriesdata.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/series.dart';

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
      this.trailerUrl});

  final SeriesData controller = Get.find();

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

  @override
  Widget build(BuildContext context) {
    int favIndex = controller.favourites.indexWhere(
      (element) {
        return element.title == title;
      },
    );

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
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          if (favIndex < 0) {
                            controller.favourites.add(
                              Series(
                                endDate: endDate,
                                episodeLength: episodeLength,
                                episodes: episodes,
                                image: image,
                                rating: rating,
                                startDate: startDate,
                                status: status,
                                synopsis: synopsis,
                                title: title,
                                titleJapanese: titleJapanese,
                                trailerUrl: trailerUrl,
                              ),
                            );
                          } else {
                            controller.favourites.removeAt(favIndex);
                          }
                        },
                        icon: Icon(
                          favIndex < 0 ? Icons.star_border : Icons.star,
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
              ),
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
