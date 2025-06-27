import 'package:flutter/material.dart';

class CafesScreen extends StatelessWidget {
  const CafesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_cafe, size: 80, color: Colors.brown),
          SizedBox(height: 10),
          Text('Sección de Cafeterías', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de cafeterías...'),
        ],
      ),
    );
  }
}