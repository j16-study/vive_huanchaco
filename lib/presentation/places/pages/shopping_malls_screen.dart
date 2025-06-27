// vive_huanchaco/lib/features/places/presentation/pages/shopping_malls_screen.dart
import 'package:flutter/material.dart';
class ShoppingMallsScreen extends StatelessWidget {
  const ShoppingMallsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.deepOrange),
          SizedBox(height: 10),
          Text('Sección de Centros Comerciales', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de centros comerciales...'),
        ],
      ),
    );
  }
}