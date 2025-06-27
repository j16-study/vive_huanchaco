// vive_huanchaco/lib/features/places/presentation/pages/parks_screen.dart
import 'package:flutter/material.dart';
class ParksScreen extends StatelessWidget {
  const ParksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.park, size: 80, color: Colors.green),
          SizedBox(height: 10),
          Text('Sección de Parques', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de parques...'),
        ],
      ),
    );
  }
}