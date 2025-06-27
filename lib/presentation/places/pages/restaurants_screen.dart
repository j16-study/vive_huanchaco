// vive_huanchaco/lib/features/places/presentation/pages/restaurants_screen.dart
import 'package:flutter/material.dart';
class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 80, color: Colors.orange),
          SizedBox(height: 10),
          Text('Sección de Restaurantes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de restaurantes...'),
        ],
      ),
    );
  }
}