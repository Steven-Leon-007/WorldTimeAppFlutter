import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:world_time_app/pages/choose_location.dart';
import 'package:world_time_app/shared/shared_text_main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    // Here in the build we receive the data from the widget
    // The context let know the widget where to search for the data (the past widget)
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map;

    String bgImage =
        data["isDayTime"] ? "assets/daytime.jpg" : "assets/nighttime.jpg";

    Color? buttonBgColor =
        data["isDayTime"] ? Colors.amber[700] : Colors.indigo[400];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: () async {
                  // Push another screen on top of the current screen, takes context to know where it is
                  dynamic newData = await Navigator.push(
                      context,
                      PageTransition(
                          child: const ChooseLocation(),
                          type: PageTransitionType.rightToLeft,
                          settings: RouteSettings(arguments: {
                            "locations": data["locations"],
                          })));
                  setState(() {
                    // Here we set the state to trigger a re-build with the new data
                    if (newData != null) {
                      data = {
                        "location": newData["location"],
                        "flag": newData["flag"],
                        "time": newData["time"],
                        "isDayTime": newData["isDayTime"],
                        "locations": newData["locations"],
                      };
                    }
                  });
                },
                icon: const Icon(Icons.edit_location),
                label: const Text("Edit location"),
                style: FilledButton.styleFrom(backgroundColor: buttonBgColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SharedTextMain(
                      data["location"], 28, Colors.white, FontWeight.normal)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SharedTextMain(data["time"], 48, Colors.white, FontWeight.bold),
            ],
          ),
        ),
      ),
    );
  }
}
