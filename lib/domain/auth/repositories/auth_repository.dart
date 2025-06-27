import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> registerUser(
    String email, 
    String password,
    String fullName,
    String lastName,
    DateTime dateOfBirth,
    String gender,
    String country
    );
  Future<Either<Failure, User>> loginUser(String email, String password);
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, User?>> getCurrentUser();
}