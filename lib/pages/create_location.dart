
import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time.dart';
import 'package:world_time_app/shared/shared_text_main.dart';

class Createlocation extends StatefulWidget {
  const Createlocation({super.key});

  @override
  State<Createlocation> createState() => _CreatelocationState();
}

class _CreatelocationState extends State<Createlocation> {
  List<String> possibleLocations = [];
  String dropdownValue = "";

  void addNewLocation(String location) async {
    // I need to make a method to build a WorldTime Object based on the location string
    if (location.isNotEmpty) {
      WorldTime instance = WorldTime.createLocationFromString(location);
      await instance.getTime();
      if (mounted) {
        Navigator.pop(context, instance);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    possibleLocations = List<String>.from(data['possibleLocations'] as List);

    dropdownValue =
        dropdownValue.isEmpty ? possibleLocations.first : dropdownValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create location"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              items: possibleLocations
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: FilledButton(
                onPressed: () {
                  addNewLocation(dropdownValue);
                },
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
