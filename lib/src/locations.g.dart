// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      coords: LatLng.fromJson(json['coords'] as Map<String, dynamic>),
      id: json['id'] as String,
      name: json['name'] as String,
      zoom: (json['zoom'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'coords': instance.coords,
      'id': instance.id,
      'name': instance.name,
      'zoom': instance.zoom,
    };

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      address: json['address'] as String,
      severity: json['severity'] as String,
      id: json['id'] as String,
      size: (json['size'] as num).toDouble(),
      // image: json['image'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
      // phone: json['phone'] as String,
      // location: json['location'] as String,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'address': instance.address,
      'severity': instance.severity,
      'id': instance.id,
      // 'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      // 'phone': instance.phone,
      // 'location': instance.location,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      places: (json['places'] as List<dynamic>)
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'places': instance.places,
      'locations': instance.locations,
    };