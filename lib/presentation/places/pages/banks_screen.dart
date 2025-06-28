import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Asegúrate de tener font_awesome_flutter en pubspec.yaml

class BanksScreen extends StatelessWidget {
  const BanksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.circleDollarToSlot, size: 80, color: Colors.blueGrey), // Icono de banco
          SizedBox(height: 10),
          Text('Sección de Bancos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Contenido de bancos...'),
        ],
      ),
    );
  }
}