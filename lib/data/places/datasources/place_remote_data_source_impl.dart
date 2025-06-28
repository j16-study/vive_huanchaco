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

  // --- IMPLEMENTACIÓN DE NUEVOS MÉTODOS ---

  @override
  Future<void> addPlaceToFavorites(String userId, String placeId) async {
    try {
      final userRef = firestore.collection('users').doc(userId);
      await userRef.update({
        'favoritePlaces': FieldValue.arrayUnion([placeId])
      });
    } catch (e) {
      throw ServerException(message: 'Error al añadir a favoritos: ${e.toString()}');
    }
  }

  @override
  Future<void> removePlaceFromFavorites(String userId, String placeId) async {
    try {
      final userRef = firestore.collection('users').doc(userId);
      await userRef.update({
        'favoritePlaces': FieldValue.arrayRemove([placeId])
      });
    } catch (e) {
      throw ServerException(message: 'Error al remover de favoritos: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getUserFavoritePlacesIds(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data()!.containsKey('favoritePlaces')) {
        return List<String>.from(userDoc.data()!['favoritePlaces']);
      }
      return [];
    } catch (e) {
      throw ServerException(message: 'Error al obtener favoritos: ${e.toString()}');
    }
  }

  @override
  Future<void> submitReview(String placeId, String userId, double rating, String comment) async {
    try {
      final placeRef = firestore.collection('places').doc(placeId);
      final reviewRef = placeRef.collection('reviews').doc(); // Nuevo documento de reseña

      await reviewRef.set({
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar la calificación promedio del lugar (opcional pero recomendado)
      // Esto se puede hacer de forma más robusta con Cloud Functions
      // para evitar condiciones de carrera.
      // Por simplicidad, aquí se hace una transacción.
      await firestore.runTransaction((transaction) async {
        final placeSnapshot = await transaction.get(placeRef);
        if (!placeSnapshot.exists) {
          throw Exception("¡El lugar no existe!");
        }

        final reviewsSnapshot = await placeRef.collection('reviews').get();
        double totalRating = 0;
        for (var doc in reviewsSnapshot.docs) {
          totalRating += (doc.data()['rating'] as num).toDouble();
        }
        final newAverageRating = totalRating / reviewsSnapshot.docs.length;
        
        transaction.update(placeRef, {'rating': newAverageRating});
      });

    } catch (e) {
      throw ServerException(message: 'Error al enviar reseña: ${e.toString()}');
    }
  }
  // --- FIN DE LA IMPLEMENTACIÓN ---

}
