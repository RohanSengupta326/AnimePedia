import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoFavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // error image
            Container(
              height: 300,
              width: 150,
              child: Image.asset(
                'assets/images/goku.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'No Favourites to show!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Add your favourite Animes!',
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // try again button
          ],
        ),
      ),
    );
  }
}
