// vive_huanchaco/lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> registerWithEmailAndPassword(String email, String password);
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Error desconocido al registrar.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Error desconocido al iniciar sesión.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }
}

