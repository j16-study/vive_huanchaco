// vive_huanchaco/lib/features/places/domain/repositories/place_repository.dart
import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/failures.dart'; // Asegúrate de tener tu clase Failure
//import 'package.com.example.vive_huanchaco.features.places.domain.entities.place.Place; // Asegúrate de tener tu entidad Place
import 'package:vive_huanchaco/domain/places/entities/place.dart';


abstract class PlaceRepository {
  Future<Either<Failure, List<Place>>> getPlaces();
  Future<Either<Failure, List<Place>>> getPlacesByCategory(String category);
  Future<Either<Failure, Place>> addPlace(Place place);
}