import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world_time_app/pages/locations_element_builder.dart';
import 'package:world_time_app/services/locations_zones.dart';
import 'package:world_time_app/services/world_time.dart';
import 'package:world_time_app/shared/shared_text_main.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [];
  List possibleLocations = [];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getTime();

    if (mounted) {
      // pop works as in stacks, so we take out the element above and remove it, letting the behind one.
      // pop and push if we're not getting back the element behind, just pop if we're doing it.
      Navigator.pop(context, {
        "location": instance.locationName,
        "flag": instance.flagUri,
        "time": instance.time,
        "isDayTime": instance.isDayTime,
        "locations": locations,
      });
    }
  }

  void loadLocations() async {
    if (possibleLocations.isEmpty) {
      LocationsZones instance =
          LocationsZones(possibleLocations: possibleLocations);
      possibleLocations = await instance.getPossibleLocations();
    }
  }

  void addLocation() async {
    while (possibleLocations.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (mounted) {
      dynamic newLocation =
          await Navigator.pushNamed(context, "/create", arguments: {
        "possibleLocations": possibleLocations,
      });

      // here goes the setState for update the list and to trigger a re-build
      if (newLocation != null) {
        locations.add(newLocation);

        // here we will write the new location in the JSON file
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        File file = File("$path/locations.json");

        List newLocations =
            locations.map((location) => location.toJson()).toList();

        file.writeAsStringSync(jsonEncode(newLocations));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    locations = data["locations"] as List<WorldTime>;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Choose Location"),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        // Arrow button pops the screen out of the widget tree and returns to the back one
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LocationsElementBuilder(
                locations: locations, updateTime: updateTime),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FilledButton(
                onPressed: addLocation,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const SharedTextMain(
                    "Add Location", 18, Colors.white, FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
