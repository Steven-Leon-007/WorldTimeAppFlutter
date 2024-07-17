import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world_time_app/pages/home.dart';
import 'package:world_time_app/services/world_time.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // int counter = 0;
  // String? about;

  // void getData() async {
  //   // simulates a network request for an username
  //   // the second argument is the function that triggers when the delay is reached
  //   String username = await Future.delayed(const Duration(seconds: 3), () {
  //     return "yoshi";
  //   });

  //   // let's say we need a second request but it needs the data of the first one
  //   // the await will make the function wait till the promise is fulfilled, and the run this

  //   String info = await Future.delayed(const Duration(seconds: 2), () {
  //     return "Musician and that stuff";
  //   });

  //   setState(() {
  //     // this setState will toggle a re-buildx
  //     about = "$username: $info";
  //   });
  // }

  // @override
  // void initState() {
  //   // Runs first when state object is created, I guess here we get API data
  //   // We will use asynchronous code, means that starts now and finishes later on
  //   super.initState();
  //   getData();
  //   print("This will not be blocked by the async code behind it");
  // }

  void setupWorldTime() async {
    WorldTime instance = WorldTime(locationName: "", flagUri: "", cityUrl: "");
    await instance.getUserIpTime();

    // Here we will call the data loader for pass it to the next screen to be used
    List<WorldTime> locations = await fetchLocations();

    // We will not use pushNamed cause we don't want the loading screen to keep in the stack of screens
    // pushReplacementNamed does the same but it replace the route underneath
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const Home(),
              type: PageTransitionType.bottomToTop,
              settings: RouteSettings(arguments: {
                "location": instance.locationName,
                "flag": instance.flagUri,
                "time": instance.time,
                "isDayTime": instance.isDayTime,
                "locations": locations,
              })));
    }
  }

  Future<File> _initializeFile() async {
    final localDirectory = await getApplicationDocumentsDirectory();
    String appDocPath = localDirectory.path;
    final file = File('$appDocPath/locations.json');

    if (!await file.exists()) {
      // read the file from assets first and create the local file with its contents
      final initialContent =
          await rootBundle.loadString("assets/data/locations.json");
      await file.create();
      await file.writeAsString(initialContent);
    }

    return file;
  }

  Future<List<WorldTime>> fetchLocations() async {
    final file = await _initializeFile();
    final String locations = await file.readAsString();
    final List<dynamic> data = convert.jsonDecode(locations);

    return data.map((location) => WorldTime.fromJson(location)).toList();
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
