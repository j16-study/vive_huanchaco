import 'package:flutter/material.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.redAccent),
          SizedBox(height: 10),
          Text(
            'Tus Lugares Favoritos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Aquí verás los lugares que has marcado como favoritos.'),
        ],
      ),
    );
  }
}