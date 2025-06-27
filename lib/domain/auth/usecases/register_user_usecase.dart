import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // Importa Equatable
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart';
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart';

class RegisterUserUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.registerUser(
      params.email,
      params.password,
      params.fullName!,
      params.lastName!,
      params.dateOfBirth!,
      params.gender!,
      params.country!,
      );
  }
}

class RegisterParams extends Equatable { // Corregido: 'extends Equatable' a 'with EquatableMixin'
  final String email;
  final String password;
  final String confirmPassword;
  final String? fullName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.fullName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.country,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword, fullName, lastName, dateOfBirth, gender, country];
}