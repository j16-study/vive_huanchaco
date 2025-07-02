// lib/data/places/datasources/google_places_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vive_huanchaco/data/places/models/place_api_models.dart';

class GooglePlacesDataSource {
  final String _apiKey = "API_KEY_HERE"; // Tu API Key
  final String _baseUrl = "https://places.googleapis.com/v1/places:searchNearby";

  Future<List<Place>> searchNearby(String type, Location centerLocation) async {
    final url = Uri.parse(_baseUrl);

    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      // FieldMask para pedir solo los campos que necesitamos
      'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location,places.rating,places.photos,places.name',
    };

    final body = json.encode({
      "includedTypes": [type],
      "maxResultCount": 10, // Podemos pedir hasta 20
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": centerLocation.latitude,
            "longitude": centerLocation.longitude
          },
          "radius": 5000.0 // 5km
        }
      },
      "languageCode": "en"
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return SearchNearbyResponse.fromJson(decodedResponse).places;
    } else {
      // Imprimimos el error para depuración
      print("Error en la API de Places (New): ${response.body}");
      throw Exception('Falló la carga de lugares');
    }
  }

  // La URL de la foto ahora se construye con el "name" de la foto
  String getPhotoUrl(String photoName) {
    return "https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&key=$_apiKey";
  }
}