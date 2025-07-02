// lib/data/places/models/place_api_models.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Modelo para la respuesta principal de la API
class SearchNearbyResponse {
  final List<Place> places;

  SearchNearbyResponse({required this.places});

  factory SearchNearbyResponse.fromJson(Map<String, dynamic> json) {
    if (json['places'] == null) {
      return SearchNearbyResponse(places: []);
    }
    var placesList = json['places'] as List;
    List<Place> placeObjects = placesList.map((p) => Place.fromJson(p)).toList();
    return SearchNearbyResponse(places: placeObjects);
  }
}

// Modelo para cada lugar individual
class Place {
  final String name; // El ID en el formato "places/ChIJ..."
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
    var photoList = json['photos'] as List?;
    return Place(
      name: json['name'] ?? '',
      displayName: DisplayName.fromJson(json['displayName'] ?? {'text': 'Nombre no disponible'}),
      formattedAddress: json['formattedAddress'],
      location: Location.fromJson(json['location'] ?? {'latitude': 0.0, 'longitude': 0.0}),
      rating: (json['rating'] as num?)?.toDouble(),
      photos: photoList?.map((p) => Photo.fromJson(p)).toList(),
    );
  }

  LatLng get latLng => LatLng(location.latitude, location.longitude);
}

// --- Sub-modelos ---

class DisplayName {
  final String text;
  final String languageCode;

  DisplayName({required this.text, required this.languageCode});

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(text: json['text'], languageCode: json['languageCode'] ?? 'es');
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(latitude: json['latitude'], longitude: json['longitude']);
  }
}

class Photo {
  // El name de la foto es su identificador único, ej: "places/ChIJ.../photos/Aap..."
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