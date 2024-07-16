import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

class WorldTime {
  String locationName;
  late String time;
  String flagUri;
  String cityUrl;
  late bool isDayTime;

  WorldTime(
      {required this.locationName,
      required this.flagUri,
      required this.cityUrl});

  Future<void> getTime() async {
    try {
      Response res =
          await get(Uri.https('worldtimeapi.org', '/api/timezone/$cityUrl'));

      Map data = convert.jsonDecode(res.body);

      // get props from data
      String dayTime = data["datetime"];
      String offset = data["utc_offset"].substring(0, 3);

      // convert to DateTime object
      DateTime now = DateTime.parse(dayTime);
      now = now.add(Duration(hours: int.parse(offset)));

      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;

      time = DateFormat.jm().format(now);
    } catch (e) {
      time = "couldn't get time data";
    }
  }

  factory WorldTime.fromJson(Map<String, dynamic> json) {
    return WorldTime(
      locationName: json['locationName'],
      flagUri: json['flagUri'],
      cityUrl: json['cityUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["locationName"] = locationName;
    data["flagUri"] = flagUri;
    data["cityUrl"] = cityUrl;
    return data;
  }

  factory WorldTime.createLocationFromString(String locationUri) {
    // We must extract the name of the location, after the last "/"
    String locationName =
        locationUri.substring(locationUri.lastIndexOf("/") + 1);
    locationName = locationName.replaceAll(RegExp(r'_'), ' ');

    return WorldTime(
        locationName: locationName,
        flagUri: "earth_illustration.png",
        cityUrl: locationUri);
  }
}
