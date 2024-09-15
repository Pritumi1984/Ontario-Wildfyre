import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Location {
  Location({
    required this.coords,
    required this.id,
    required this.name,
    required this.zoom,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class Place {
  Place({
    required this.address,
    required this.severity,
    required this.id,
    required this.size,
    // required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    // required this.phone,
    // required this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  final String address;
  final String severity;
  final String id;
  final double size;
  // final String image;
  final double lat;
  final double lng;
  final String name;
  // final String phone;
  // final String location;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.places,
    required this.locations,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Place> places;
  final List<Location> locations;
}

Future<Locations> getFireLocations() async {
  const googleLocationsURL = '../../assets/locations.json'; //let it be a github page instead, updated by a service.
  // const googleLocationsURL = 'https://about.google/static/data/locations.json'; //let it be a github page instead, updated by a service.

  // Retrieve the locations of Google places
  try {
    final response = await http.get(Uri.parse(googleLocationsURL));
    if (response.statusCode == 200) {
      return Locations.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/locations.json'),
    ) as Map<String, dynamic>,
  );
}