// vive_huanchaco/lib/features/places/data/repositories/place_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/data/places/datasources/place_remote_data_source.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';
import 'package:vive_huanchaco/domain/places/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;

  PlaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Place>>> getPlaces() async {
    try {
      final result = await remoteDataSource.getPlaces();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Place>>> getPlacesByCategory(String category) async {
    try {
      final result = await remoteDataSource.getPlacesByCategory(category);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Place>> addPlace(Place place) async {
    try {
      final result = await remoteDataSource.addPlace(place);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}