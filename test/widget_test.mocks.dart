
import 'dart:async' as _i6;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:vive_huanchaco/core/error/failures.dart' as _i7;
import 'package:vive_huanchaco/core/usecases/usecase.dart' as _i11;
import 'package:vive_huanchaco/domain/auth/entities/user.dart' as _i8;
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart'    as _i2;
import 'package:vive_huanchaco/domain/auth/usecases/login_user_usecase.dart'   as _i9;
import 'package:vive_huanchaco/domain/auth/usecases/logout_user_usecase.dart'    as _i10;
import 'package:vive_huanchaco/domain/auth/usecases/register_user_usecase.dart'    as _i5;
import 'package:vive_huanchaco/domain/places/entities/place.dart'    as _i13;
import 'package:vive_huanchaco/domain/places/repositories/place_repository.dart'   as _i4;
import 'package:vive_huanchaco/domain/places/usecases/add_place_usecase.dart'    as _i15;
import 'package:vive_huanchaco/domain/places/usecases/get_places_by_category_usecase.dart'   as _i14;
import 'package:vive_huanchaco/domain/places/usecases/get_places_usecase.dart'   as _i12;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthRepository_0 extends _i1.SmartFake
    implements _i2.AuthRepository {
  _FakeAuthRepository_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakePlaceRepository_2 extends _i1.SmartFake
    implements _i4.PlaceRepository {
  _FakePlaceRepository_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [RegisterUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegisterUserUseCase extends _i1.Mock
    implements _i5.RegisterUserUseCase {
  MockRegisterUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeAuthRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.AuthRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, _i8.User>> call(
    _i5.RegisterParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i6.Future<_i3.Either<_i7.Failure, _i8.User>>.value(
              _FakeEither_1<_i7.Failure, _i8.User>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, _i8.User>>);
}

/// A class which mocks [LoginUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUserUseCase extends _i1.Mock implements _i9.LoginUserUseCase {
  MockLoginUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeAuthRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.AuthRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, _i8.User>> call(_i9.LoginParams? params) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i6.Future<_i3.Either<_i7.Failure, _i8.User>>.value(
              _FakeEither_1<_i7.Failure, _i8.User>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, _i8.User>>);
}

/// A class which mocks [LogoutUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutUserUseCase extends _i1.Mock implements _i10.LogoutUserUseCase {
  MockLogoutUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeAuthRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.AuthRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, void>> call(_i11.NoParams? params) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i6.Future<_i3.Either<_i7.Failure, void>>.value(
              _FakeEither_1<_i7.Failure, void>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, void>>);
}

/// A class which mocks [GetPlacesUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetPlacesUseCase extends _i1.Mock implements _i12.GetPlacesUseCase {
  MockGetPlacesUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.PlaceRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakePlaceRepository_2(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i4.PlaceRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>> call(
    _i11.NoParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue:
                _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>>.value(
                  _FakeEither_1<_i7.Failure, List<_i13.Place>>(
                    this,
                    Invocation.method(#call, [params]),
                  ),
                ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>>);
}

/// A class which mocks [GetPlacesByCategoryUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetPlacesByCategoryUseCase extends _i1.Mock
    implements _i14.GetPlacesByCategoryUseCase {
  MockGetPlacesByCategoryUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.PlaceRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakePlaceRepository_2(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i4.PlaceRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>> call(
    _i14.GetPlacesByCategoryParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue:
                _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>>.value(
                  _FakeEither_1<_i7.Failure, List<_i13.Place>>(
                    this,
                    Invocation.method(#call, [params]),
                  ),
                ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, List<_i13.Place>>>);
}

/// A class which mocks [AddPlaceUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddPlaceUseCase extends _i1.Mock implements _i15.AddPlaceUseCase {
  MockAddPlaceUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.PlaceRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakePlaceRepository_2(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i4.PlaceRepository);

  @override
  _i6.Future<_i3.Either<_i7.Failure, _i13.Place>> call(
    _i15.AddPlaceParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i6.Future<_i3.Either<_i7.Failure, _i13.Place>>.value(
              _FakeEither_1<_i7.Failure, _i13.Place>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i6.Future<_i3.Either<_i7.Failure, _i13.Place>>);
}
