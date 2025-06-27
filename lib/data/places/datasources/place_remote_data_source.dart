// vive_huanchaco/lib/features/places/data/datasources/place_remote_data_source.dart
import 'package:vive_huanchaco/domain/places/entities/place.dart';

abstract class PlaceRemoteDataSource {
  Future<List<Place>> getPlaces();
  Future<List<Place>> getPlacesByCategory(String category);
  Future<Place> addPlace(Place place);
  // Puedes añadir más métodos según sea necesario (e.g., updatePlace, deletePlace, getPlaceById)
}
