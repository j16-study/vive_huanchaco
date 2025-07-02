// lib/data/places/datasources/google_places_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vive_huanchaco/data/places/models/place_api_models.dart';

class GooglePlacesDataSource {
  final String _apiKey = "AIzaSyB-LMjIWKJb3eb6qmIBf7UGWsrIyRwvhxc"; // ← reemplaza con tu API KEY real
  final String _baseUrl = "https://places.googleapis.com/v1/places:searchNearby";

  Future<List<Place>> searchNearby(String type, Location centerLocation, {double radius = 1000.0}) async {
    final url = Uri.parse(_baseUrl);

    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask':
          'places.displayName,places.formattedAddress,places.location,places.rating,places.photos,places.name',
    };

    final body = json.encode({
      "includedTypes": [type],
      "maxResultCount": 20,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": centerLocation.latitude,
            "longitude": centerLocation.longitude
          },
          "radius": radius
        }
      },
      "languageCode": "es"
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return SearchNearbyResponse.fromJson(decoded).places;
    } else {
      print("❌ Error de Places API: ${response.body}");
      return [];
    }
  }

  String getPhotoUrl(String photoName) {
    return "https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&key=$_apiKey";
  }
}
