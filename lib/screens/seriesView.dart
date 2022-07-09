import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SeriesView extends StatefulWidget {
  final String image;
  final String title;

  SeriesView(this.image, this.title);
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
            backgroundColor: /* Color.fromARGB(255, 40, 40, 40) */ Colors.white,
            title: Center(
              child: Text(
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                widget.title,
                style: TextStyle(
                  color: /* Colors.white */ Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          child: GestureDetector(
            // anime details page
            onTap: () {},
            child: Image.network(
              widget.image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
