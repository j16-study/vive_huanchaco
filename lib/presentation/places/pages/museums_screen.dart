// vive_huanchaco/lib/features/places/presentation/pages/museums_screen.dart
import 'package:flutter/material.dart';
class MuseumsScreen extends StatelessWidget {
  const MuseumsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.museum, size: 80, color: Colors.brown),
          SizedBox(height: 10),
          Text('Sección de Museos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de museos...'),
        ],
      ),
    );
  }
}