import 'dart:convert' as convert;

import 'package:http/http.dart';

class LocationsZones {
  List possibleLocations;

  LocationsZones({required this.possibleLocations});

  Future<List> getPossibleLocations() async {
    try {
      Response res = await get(Uri.https('worldtimeapi.org', '/api/timezone'));
      possibleLocations = convert.jsonDecode(res.body);

      return possibleLocations;
    } catch (e) {
      return [];
    }
  }
}
