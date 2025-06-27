import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart' as app_user; // Alias para evitar conflicto
import 'package:vive_huanchaco/data/auth/datasources/auth_remote_data_source.dart';
import 'package:vive_huanchaco/data/auth/datasources/auth_local_data_source.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, app_user.User>> registerUser(
    String email,
    String password,
    String fullName,
    String lastName,
    DateTime dateOfBirth,
    String gender,
    String country) async {
    
    try {
      final userCredential = await remoteDataSource.registerWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        final userId = userCredential.user!.uid;
        final userData = {
          'fullName': fullName,
          'lastName': lastName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'country': country,
          'email': email,
        };

        await remoteDataSource.saveUserData(userData, userId);

        await localDataSource
            .cacheUserToken(await userCredential.user!.getIdToken() ?? '');
        return Right(app_user.User(
          id: userId,
          email: userCredential.user!.email,
          fullName: fullName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          country: country,
        ));
      } else {
        return const Left(AuthFailure(message: 'Error al obtener usuario después del registro.'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, app_user.User>> loginUser(String email, String password) async {
    try {
      final userCredential = await remoteDataSource.signInWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        await localDataSource.cacheUserToken(await userCredential.user!.getIdToken() ?? '');
        return Right(app_user.User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email,
        ));
      } else {
        return const Left(AuthFailure(message: 'Error al obtener usuario después del login.'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.deleteUserToken(); // Limpiar token local al cerrar sesión
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, app_user.User?>> getCurrentUser() async {
    try {
      final firebaseUser = await remoteDataSource.getCurrentUser();
      if (firebaseUser != null) {
        return Right(app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
        ));
      } else {
        return const Right(null); // No hay usuario logueado
      }
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
