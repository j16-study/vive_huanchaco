import 'package:vive_huanchaco/domain/places/entities/place.dart';

abstract class PlaceRemoteDataSource {
  Future<List<Place>> getPlaces();
  Future<List<Place>> getPlacesByCategory(String category);
  Future<Place> addPlace(Place place);
  
  // --- NUEVOS MÉTODOS ---
  Future<void> addPlaceToFavorites(String userId, String placeId);
  Future<void> removePlaceFromFavorites(String userId, String placeId);
  Future<List<String>> getUserFavoritePlacesIds(String userId);
  Future<void> submitReview(String placeId, String userId, double rating, String comment);
}
