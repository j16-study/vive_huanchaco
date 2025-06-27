// vive_huanchaco/lib/features/places/data/datasources/place_remote_data_source_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';
import 'package:vive_huanchaco/data/places/datasources/place_remote_data_source.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final FirebaseFirestore firestore;

  PlaceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Place>> getPlaces() async {
    try {
      final QuerySnapshot snapshot = await firestore.collection('places').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Place(
          id: doc.id,
          name: data['name'] ?? 'Nombre Desconocido',
          description: data['description'] ?? 'Sin descripción.',
          category: data['category'] ?? 'General',
          location: LatLng(data['latitude'] ?? 0.0, data['longitude'] ?? 0.0),
          rating: (data['rating'] as num?)?.toDouble(),
          imageUrl: data['imageUrl'],
          address: data['address'],
          phoneNumber: data['phoneNumber'],
          website: data['website'],
        );
      }).toList();
    } catch (e) {
      throw ServerException(message: 'Error al obtener lugares: ${e.toString()}');
    }
  }

  @override
  Future<List<Place>> getPlacesByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await firestore.collection('places').where('category', isEqualTo: category).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Place(
          id: doc.id,
          name: data['name'] ?? 'Nombre Desconocido',
          description: data['description'] ?? 'Sin descripción.',
          category: data['category'] ?? 'General',
          location: LatLng(data['latitude'] ?? 0.0, data['longitude'] ?? 0.0),
          rating: (data['rating'] as num?)?.toDouble(),
          imageUrl: data['imageUrl'],
          address: data['address'],
          phoneNumber: data['phoneNumber'],
          website: data['website'],
        );
      }).toList();
    } catch (e) {
      throw ServerException(message: 'Error al obtener lugares por categoría: ${e.toString()}');
    }
  }

  @override
  Future<Place> addPlace(Place place) async {
    try {
      final docRef = await firestore.collection('places').add({
        'name': place.name,
        'description': place.description,
        'category': place.category,
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'rating': place.rating,
        'imageUrl': place.imageUrl,
        'address': place.address,
        'phoneNumber': place.phoneNumber,
        'website': place.website,
      });
      return place.copyWith(id: docRef.id); // Asigna el ID generado por Firestore
    } catch (e) {
      throw ServerException(message: 'Error al añadir lugar: ${e.toString()}');
    }
  }
}
