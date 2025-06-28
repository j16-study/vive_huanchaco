import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';

abstract class PlaceRepository {
  Future<Either<Failure, List<Place>>> getPlaces();
  Future<Either<Failure, List<Place>>> getPlacesByCategory(String category);
  Future<Either<Failure, Place>> addPlace(Place place);

  // --- NUEVOS MÉTODOS ---
  Future<Either<Failure, void>> addPlaceToFavorites(String userId, String placeId);
  Future<Either<Failure, void>> removePlaceFromFavorites(String userId, String placeId);
  Future<Either<Failure, List<String>>> getUserFavoritePlacesIds(String userId);
  Future<Either<Failure, void>> submitReview(String placeId, String userId, double rating, String comment);
  // Podríamos añadir un método para obtener reseñas si fuera necesario
}