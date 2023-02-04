import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

import 'home_screen.dart';

class Splash2 extends StatelessWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const HomeScreen(),
      // title: new Text(
      //   'GeeksForGeeks',
      //   textScaleFactor: 2,
      // ),
      imageBackground: const AssetImage('assets/splash.png'),

      loadingText: const Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
      // backgroundColor: Colors.deepOrange,
    );
  }
}
