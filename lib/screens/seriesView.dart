import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/screens/animeDetailPage.dart';

class SeriesView extends StatefulWidget {
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

  SeriesView(
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
  @override
  State<SeriesView> createState() => _SeriesViewState();
}

class _SeriesViewState extends State<SeriesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                widget.title ?? '', 
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                
                style: const TextStyle(
                  color: /* Colors.white */ Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          child: GestureDetector(
            // anime details page
            onTap: () {
              Get.to(AnimeDetailPage(
                title: widget.title,
                image: widget.image,
                endDate: widget.endDate,
                episodeLength: widget.episodeLength,
                episodes: widget.episodes,
                rating: widget.rating,
                startDate: widget.startDate,
                status: widget.status,
                synopsis: widget.synopsis,
                titleJapanese: widget.titleJapanese,
                trailerUrl: widget.trailerUrl,
              ));
            },
            child: widget.image == null
                ? const Text(
                    'No Preview Available',
                    style: TextStyle(
                      color: Colors.white38,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
