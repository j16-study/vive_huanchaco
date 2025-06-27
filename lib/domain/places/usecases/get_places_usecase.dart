// vive_huanchaco/lib/features/places/domain/usecases/get_places_usecase.dart
//import 'package:dartz/dartz.h';
import 'package:dartz/dartz.dart';

import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
//import 'package.com.example.vive_huanchaco.core.usecases.usecase.NoParams; // Asegúrate de importar NoParams
import 'package:vive_huanchaco/domain/places/entities/place.dart';
//import 'package.com.example.vive_huanchaco.core.usecases.usecase.UseCase; // Asegúrate de importar UseCase
//import 'package.com.example.vive_huanchaco.features.places.domain.entities.place.Place; // Asegúrate de importar Place
import 'package:vive_huanchaco/domain/places/repositories/place_repository.dart';
//import 'package.com.example.vive_huanchaco.features.places.domain.repositories.place_repository.PlaceRepository; // Asegúrate de importar PlaceRepository

class GetPlacesUseCase implements UseCase<List<Place>, NoParams> {
  final PlaceRepository repository;

  GetPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Place>>> call(NoParams params) async {
    return await repository.getPlaces();
  }
}