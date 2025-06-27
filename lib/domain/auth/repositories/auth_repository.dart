// vive_huanchaco/lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> registerUser(String email, String password);
  Future<Either<Failure, User>> loginUser(String email, String password);
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, User?>> getCurrentUser();
}