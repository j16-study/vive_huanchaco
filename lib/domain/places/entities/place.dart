// vive_huanchaco/lib/features/places/domain/entities/place.dart
import 'package:equatable/equatable.dart';
//import 'package:Maps_flutter/Maps_flutter.dart'; // Para LatLng
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category; // Ej: 'Museo', 'Hotel', 'Restaurante'
  final LatLng location; // Latitud y Longitud
  final double? rating; // Calificación promedio
  final String? imageUrl; // URL de una imagen del lugar
  final String? address;
  final String? phoneNumber;
  final String? website;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    this.rating,
    this.imageUrl,
    this.address,
    this.phoneNumber,
    this.website,
  });

  // Método copyWith para facilitar la creación de nuevas instancias con cambios
  Place copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    LatLng? location,
    double? rating,
    String? imageUrl,
    String? address,
    String? phoneNumber,
    String? website,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    location,
    rating,
    imageUrl,
    address,
    phoneNumber,
    website,
  ];
}
