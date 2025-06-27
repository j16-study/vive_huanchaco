// vive_huanchaco/lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Fallos específicos
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Error en el servidor.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Error de caché.'});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required super.message});
}