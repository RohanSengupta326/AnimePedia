import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatelessWidget {
  final void Function([bool?]) fetch;
  final String errorMsg;
  ErrorPage(this.fetch, this.errorMsg);

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
              height: 200,
              width: 70,
              child: Image.asset(
                'assets/images/anime3.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Ooops!!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              errorMsg,
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // try again button
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                // logic to refresh app
                fetch(true);
              },
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
