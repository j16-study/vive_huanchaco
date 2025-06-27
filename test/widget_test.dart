// File: test/widget_test.dart
// --- a/test/widget_test.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vive_huanchaco/domain/places/entities/place.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart'; // <--- Importa esto
import 'package:mockito/mockito.dart'; // <--- Importa esto
import 'package:vive_huanchaco/main.dart'; // Importa tu MyApp
import 'package:vive_huanchaco/domain/auth/usecases/register_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/login_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/logout_user_usecase.dart';
import 'package:vive_huanchaco/domain/places/usecases/get_places_usecase.dart'; // <--- Nueva importación
import 'package:vive_huanchaco/domain/places/usecases/get_places_by_category_usecase.dart'; // <--- Nueva importación
import 'package:vive_huanchaco/domain/places/usecases/add_place_usecase.dart'; // <--- Nueva importación

import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/domain/auth/entities/user.dart'; // Para el mock de usuario

// --- Generar los mocks para todos los use cases ---
@GenerateMocks([
  RegisterUserUseCase,
  LoginUserUseCase,
  LogoutUserUseCase,
  GetPlacesUseCase,
  GetPlacesByCategoryUseCase,
  AddPlaceUseCase,
])
import 'widget_test.mocks.dart'; // <--- Este archivo se generará automáticamente

//import 'widget_test.mocks.dart'; // <--- Este archivo se generará automáticamente

void main() {
  // Instancias de los mocks para pasar a MyApp
  late MockRegisterUserUseCase mockRegisterUserUseCase;
  late MockLoginUserUseCase mockLoginUserUseCase;
  late MockLogoutUserUseCase mockLogoutUserUseCase;
  late MockGetPlacesUseCase mockGetPlacesUseCase; // <--- Nueva instancia mock
  late MockGetPlacesByCategoryUseCase
  mockGetPlacesByCategoryUseCase; // <--- Nueva instancia mock
  late MockAddPlaceUseCase mockAddPlaceUseCase; // <--- Nueva instancia mock

  setUp(() {
    // Inicializa los mocks antes de cada prueba
    mockRegisterUserUseCase = MockRegisterUserUseCase();
    mockLoginUserUseCase = MockLoginUserUseCase();
    mockLogoutUserUseCase = MockLogoutUserUseCase();
    mockGetPlacesUseCase = MockGetPlacesUseCase(); // <--- Inicializa
    mockGetPlacesByCategoryUseCase = MockGetPlacesByCategoryUseCase(); // <--- Inicializa
    mockAddPlaceUseCase = MockAddPlaceUseCase(); // <--- Inicializa

    // Puedes configurar el comportamiento predeterminado de los mocks si es necesario para tus pruebas.
    // Por ejemplo, para evitar errores de null-safety o de llamadas no mockeadas:
    when(mockRegisterUserUseCase(any)).thenAnswer(
      (_) async => Right(User(id: 'test', email: 'test@example.com')),
    );
    when(mockLoginUserUseCase(any)).thenAnswer(
      (_) async => Right(User(id: 'test', email: 'test@example.com')),
    );
    when(mockLogoutUserUseCase(any)).thenAnswer((_) async => const Right(null));
    when(mockGetPlacesUseCase(any)).thenAnswer(
      (_) async => const Right([]),
    ); // Retorna una lista vacía de lugares por defecto
    when(
      mockGetPlacesByCategoryUseCase(any),
    ).thenAnswer((_) async => const Right([]));
    when(mockAddPlaceUseCase(any)).thenAnswer(
      (_) async => Right(
        Place(
          id: 'mock_id',
          name: 'Mock Place',
          description: 'Mock Description',
          category: 'Mock Category',
          location: LatLng(0, 0),
        ),
      ),
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        registerUserUseCase: mockRegisterUserUseCase,
        loginUserUseCase: mockLoginUserUseCase,
        logoutUserUseCase: mockLogoutUserUseCase,
        getPlacesUseCase: mockGetPlacesUseCase, // <--- Pasa la instancia mock
        getPlacesByCategoryUseCase:
            mockGetPlacesByCategoryUseCase, // <--- Pasa la instancia mock
        addPlaceUseCase: mockAddPlaceUseCase, // <--- Pasa la instancia mock
      ),
    );

    // Verify that our counter starts at 0.
    // Esto es un ejemplo de test por defecto de Flutter,
    // probablemente querrás probar tus pantallas de login/registro.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
