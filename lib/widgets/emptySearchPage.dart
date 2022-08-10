import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptySearchPage extends StatelessWidget {
  final String msg;
  EmptySearchPage(this.msg);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // error image
            SizedBox(
              height: 260,
              width: 200,
              child: Image.asset(
                'assets/images/teamten.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              msg,
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
