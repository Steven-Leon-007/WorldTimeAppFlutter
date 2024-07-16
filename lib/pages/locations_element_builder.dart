import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time.dart';
import 'package:world_time_app/shared/shared_text_main.dart';

class LocationsElementBuilder extends StatefulWidget {
  const LocationsElementBuilder(
      {required this.locations, required this.updateTime, super.key});

  final List<WorldTime> locations;
  final Function(int index) updateTime;

  @override
  State<LocationsElementBuilder> createState() =>
      _LocationsElementBuilderState();
}

class _LocationsElementBuilderState extends State<LocationsElementBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.locations.length,
        itemBuilder: (context, index) {
          // this will build a widget tree for each element in the list
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  widget.updateTime(index);
                },
                title: SharedTextMain(widget.locations[index].locationName, 20,
                    Colors.black, FontWeight.normal),
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/${widget.locations[index].flagUri}"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
