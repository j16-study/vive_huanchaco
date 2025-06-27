// vive_huanchaco/lib/features/places/presentation/pages/hotels_screen.dart
import 'package:flutter/material.dart';
class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel, size: 80, color: Colors.blueGrey),
          SizedBox(height: 10),
          Text('Sección de Hoteles', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de hoteles...'),
        ],
      ),
    );
  }
}