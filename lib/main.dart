import 'package:flutter/material.dart';
import 'homepage.dart';
import 'global.dart';
// for snackbar without context

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // print(Get.width);
    final ThemeData theme = ThemeData();
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      // for snackbar without context
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: 'Series',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // scaffoldBackgroundColor: Colors.black,
      ).copyWith(
        // backgroundColor: Colors.black,
        // brightness: Brightness.dark,
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.white,
        ),
      ),
      home:  HomePage(),
    );
  }
}
