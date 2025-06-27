// vive_huanchaco/lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart'; // Necesitarás añadir la dependencia dartz: ^0.10.1
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart' as app_user; // Alias para evitar conflicto
import 'package:vive_huanchaco/data/auth/datasources/auth_remote_data_source.dart';
import 'package:vive_huanchaco/data/auth/datasources/auth_local_data_source.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Para User de Firebase

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  // final NetworkInfo networkInfo; // Se puede agregar para manejo de red

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, app_user.User>> registerUser(String email, String password) async {
    try {
      final userCredential = await remoteDataSource.registerWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        // Opcional: Caching token si es necesario para mantener la sesión
        await localDataSource.cacheUserToken(await userCredential.user!.getIdToken() ?? '');
        return Right(app_user.User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email,
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
