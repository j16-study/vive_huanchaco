// vive_huanchaco/lib/features/auth/domain/usecases/login_user_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // Importa Equatable
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart';
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart';

class LoginUserUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}

class LoginParams extends Equatable with EquatableMixin { // Corregido: 'extends Equatable' a 'with EquatableMixin'
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}