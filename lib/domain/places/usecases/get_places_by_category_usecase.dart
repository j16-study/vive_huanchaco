// vive_huanchaco/lib/features/places/domain/usecases/get_places_by_category_usecase.dart
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

class GetPlacesByCategoryUseCase implements UseCase<List<Place>, GetPlacesByCategoryParams> {
  final PlaceRepository repository;

  GetPlacesByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Place>>> call(GetPlacesByCategoryParams params) async {
    return await repository.getPlacesByCategory(params.category);
  }
}

class GetPlacesByCategoryParams extends Equatable {
  final String category;

  const GetPlacesByCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}