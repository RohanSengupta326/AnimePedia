import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void gotToUrl() async {
    final Uri launchUri = Uri(
      scheme: 'https',
      path: trailerUrl,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(
        launchUri,
        webOnlyWindowName: '_self',
      );
    } else {
      throw 'Cant open link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber),
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
                                  text: 'Japanese : ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: titleJapanese,
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
                            height: 10,
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
                                      text: rating.toString(),
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
                            height: 10,
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
                                      text: episodes.toString(),
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
                            height: 10,
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
                                      text: episodeLength
                                          .toString()
                                          .substring(0, 6),
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
                            height: 10,
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
                                      text: status,
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
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                                height: 15,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Trailer : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    GestureDetector(
                                      onTap: () => gotToUrl(),
                                      child: const Text(
                                        'here',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
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
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
