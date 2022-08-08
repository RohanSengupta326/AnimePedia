import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<bool> hasInternetConnection() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  return (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.ethernet);
}

/// To display snackbar with basic customization
void showSnackbar({
  String titleSB = 'Alert',
  String messageSB = 'Something went wrong, please try again',
  Color backgroundColorSB = Colors.red,
  Color textColorSB = Colors.white,
  SnackPosition positionSB = SnackPosition.BOTTOM,
  Duration durationSB = const Duration(seconds: 3),
}) {
  Get.snackbar(
    titleSB,
    messageSB,
    borderRadius: 0,
    backgroundColor: backgroundColorSB,
    colorText: textColorSB,
    snackPosition: positionSB,
    duration: durationSB,
  );
}
