// vive_huanchaco/lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/core/utils/app_strings.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart';
import 'package:vive_huanchaco/domain/auth/usecases/login_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/logout_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/register_user_usecase.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  AuthBloc({
    required this.registerUserUseCase,
    required this.loginUserUseCase,
    required this.logoutUserUseCase,
  }) : super(AuthInitial()) {
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<LoginUserEvent>(_onLoginUserEvent);
    on<LogoutUserEvent>(_onLogoutUserEvent);
  }

  void _onRegisterUserEvent(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    if (event.password != event.confirmPassword) {
      emit(const AuthError(message: AppStrings.passwordsDoNotMatch));
      return;
    }

    final result = await registerUserUseCase(RegisterParams(
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      fullName: event.fullName, // [cite: 1]
      lastName: event.lastName, // [cite: 1]
      dateOfBirth: event.dateOfBirth, // [cite: 1]
      gender: event.gender, // [cite: 1]
    ));

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user, message: AppStrings.registrationSuccess)),
    );
  }

  void _onLoginUserEvent(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUserUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user, message: AppStrings.loginSuccess)),
    );
  }

  void _onLogoutUserEvent(LogoutUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(const AuthLoggedOut(message: AppStrings.logoutSuccess)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      case AuthFailure:
        return (failure as AuthFailure).message;
      case InvalidInputFailure:
        return (failure as InvalidInputFailure).message;
      default:
        return AppStrings.error;
    }
  }
}