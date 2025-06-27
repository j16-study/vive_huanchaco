// vive_huanchaco/lib/features/places/domain/usecases/add_place_usecase.dart
/*import 'package:dartz/dartz.h';
import 'package:equatable/equatable.dart';
import 'package.com.example.vive_huanchaco.core.error.failures.Failure; // Asegúrate de importar Failure
import 'package.com.example.vive_huanchaco.core.usecases.usecase.UseCase; // Asegúrate de importar UseCase
import 'package.com.example.vive_huanchaco.features.places.domain.entities.place.Place; // Asegúrate de importar Place
import 'package.com.example.vive_huanchaco.features.places.domain.repositories.place_repository.PlaceRepository; // Asegúrate de importar PlaceRepository
*/

import 'package:dartz/dartz.dart'; 
import 'package:equatable/equatable.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';
import 'package:vive_huanchaco/domain/places/repositories/place_repository.dart';

class AddPlaceUseCase implements UseCase<Place, AddPlaceParams> {
  final PlaceRepository repository;

  AddPlaceUseCase(this.repository);

  @override
  Future<Either<Failure, Place>> call(AddPlaceParams params) async {
    return await repository.addPlace(params.place);
  }
}

class AddPlaceParams extends Equatable {
  final Place place;

  const AddPlaceParams({required this.place});

  @override
  List<Object> get props => [place];
}