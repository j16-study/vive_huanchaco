part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String? fullName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country; // Añadido

  const RegisterUserEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.fullName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.country, // Añadido
  });

  @override
  List<Object> get props => [
    email,
    password,
    confirmPassword,
    if (fullName != null) fullName!,
    if (lastName != null) lastName!,
    if (dateOfBirth != null) dateOfBirth!,
    if (gender != null) gender!,
    if (country != null) country!,
  ];
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginUserEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutUserEvent extends AuthEvent {}