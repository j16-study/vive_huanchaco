import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> registerWithEmailAndPassword(String email, String password);
  Future<void> saveUserData(Map<String, dynamic> userData, String userId); // NUEVO MÉTODO
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore; // AÑADIR FIRESTORE

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore}); // AÑADIR FIRESTORE

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

  // IMPLEMENTACIÓN DEL NUEVO MÉTODO
  @override
  Future<void> saveUserData(Map<String, dynamic> userData, String userId) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      throw ServerException(message: 'Error al guardar datos del usuario.');
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

