// test_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// Reemplaza esta clave con la tuya
const String apiKey = "AIzaSyB-LMjIWKJb3eb6qmIBf7UGWsrIyRwvhxc";

void main() async {
  print("--- Iniciando prueba de la API de Google Places ---");

  final location = "-8.0777,-79.1205"; // Coordenadas de Huanchaco
  final radius = 5000;
  final type = "lodging"; // Probaremos con "Hoteles"

  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&type=$type&language=es&key=$apiKey');

  print("\nLlamando a la URL:");
  print(url);

  try {
    final response = await http.get(url);
    final data = json.decode(response.body);

    print("\n--- Respuesta de la API ---");
    print("Código de estado HTTP: ${response.statusCode}");
    print("Estado de la API de Places: ${data['status']}");

    if (data['error_message'] != null) {
      print("Mensaje de Error de la API: ${data['error_message']}");
    }

    if (data['results'] != null) {
      final resultsCount = (data['results'] as List).length;
      print("Número de resultados encontrados: $resultsCount");
      if (resultsCount > 0) {
        print("\n¡ÉXITO! La API está devolviendo lugares.");
        print("Ejemplo: ${data['results'][0]['name']}");
      }
    }
    print("\n--- Prueba finalizada ---");
  } catch (e) {
    print("\nError durante la conexión: $e");
  }
}