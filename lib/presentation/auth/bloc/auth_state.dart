// vive_huanchaco/lib/features/auth/presentation/bloc/auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  final String message;

  const AuthSuccess({required this.user, required this.message});

  @override
  List<Object> get props => [user, message];
}

class AuthLoggedOut extends AuthState {
  final String message;

  const AuthLoggedOut({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String? fullName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;


  const RegisterUserEvent({
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
  List<Object> get props => [
    // <--- CAMBIO AQUÍ: Eliminado '?'
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
  List<Object> get props => [email, password]; // <--- CAMBIO AQUÍ: Eliminado '?'
}

class LogoutUserEvent extends AuthEvent {}
