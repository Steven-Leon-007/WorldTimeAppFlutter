import 'package:flutter/material.dart';
import 'package:world_time_app/pages/choose_location.dart';
import 'package:world_time_app/pages/create_location.dart';
import 'package:world_time_app/pages/home.dart';
import 'package:world_time_app/pages/loading_screen.dart';

void main() {
  runApp(MaterialApp(
    // Context says where in the widget tree we are
    // initalRoute shouldn't be there cause loading is the entry point, but for testing purposes we can do that

    // Think of routing as a stack of screens, and be careful with overstacking

    initialRoute: "/",
    routes: {
      "/": (context) => const LoadingScreen(),
      "/home": (context) => const Home(),
      "/location": (context) => const ChooseLocation(),
      "/create": (context) => const Createlocation(),
    },
  ));
}
