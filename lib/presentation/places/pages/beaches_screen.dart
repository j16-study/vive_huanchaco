// vive_huanchaco/lib/features/places/presentation/pages/beaches_screen.dart
import 'package:flutter/material.dart';
class BeachesScreen extends StatelessWidget {
  const BeachesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.beach_access, size: 80, color: Colors.blueAccent),
          SizedBox(height: 10),
          Text('Sección de Playas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de playas...'),
        ],
      ),
    );
  }
}