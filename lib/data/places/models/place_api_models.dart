// lib/data/places/models/place_api_models.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchNearbyResponse {
  final List<Place> places;

  SearchNearbyResponse({required this.places});

  factory SearchNearbyResponse.fromJson(Map<String, dynamic> json) {
    if (json['places'] == null) return SearchNearbyResponse(places: []);
    final list = json['places'] as List;
    final results = list.map((p) => Place.fromJson(p)).toList();
    return SearchNearbyResponse(places: results);
  }
}

class Place {
  final String name;
  final DisplayName displayName;
  final String? formattedAddress;
  final Location location;
  final double? rating;
  final List<Photo>? photos;

  Place({
    required this.name,
    required this.displayName,
    this.formattedAddress,
    required this.location,
    this.rating,
    this.photos,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final photoList = json['photos'] as List?;
    return Place(
      name: json['name'] ?? '',
      displayName:
          DisplayName.fromJson(json['displayName'] ?? {'text': 'Sin nombre'}),
      formattedAddress: json['formattedAddress'],
      location: Location.fromJson(json['location']),
      rating: (json['rating'] as num?)?.toDouble(),
      photos: photoList?.map((p) => Photo.fromJson(p)).toList(),
    );
  }

  LatLng get latLng => LatLng(location.latitude, location.longitude);
}

class DisplayName {
  final String text;
  final String languageCode;

  DisplayName({required this.text, required this.languageCode});

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'] ?? 'Nombre no disponible',
      languageCode: json['languageCode'] ?? 'es',
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }
}

class Photo {
  final String name;
  final int width;
  final int height;

  Photo({required this.name, required this.width, required this.height});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'],
      width: json['widthPx'],
      height: json['heightPx'],
    );
  }
}
