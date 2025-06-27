// vive_huanchaco/lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/bloc/auth_bloc.dart';
import 'package:vive_huanchaco/presentation/places/bloc/navigation_bloc.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/presentation/auth/pages/login_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/home_screen.dart'; // Importar HomeScreen
import 'package:vive_huanchaco/domain/auth/usecases/register_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/login_user_usecase.dart';
import 'package:vive_huanchaco/domain/auth/usecases/logout_user_usecase.dart';
import 'package:vive_huanchaco/data/auth/repositories/auth_repository_impl.dart';
import 'package:vive_huanchaco/data/auth/datasources/auth_remote_data_source.dart';
import 'package:vive_huanchaco/data/auth/datasources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:vive_huanchaco/firebase_options.dart';

//nuevas importaciones:
import 'package:vive_huanchaco/presentation/places/bloc/place_bloc.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/data/places/datasources/place_remote_data_source.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/data/places/datasources/place_remote_data_source_impl.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/data/places/repositories/place_repository_impl.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/domain/places/repositories/place_repository.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/domain/places/usecases/get_places_usecase.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/domain/places/usecases/get_places_by_category_usecase.dart'; // <--- NUEVA IMPORTACIÓN
import 'package:vive_huanchaco/domain/places/usecases/add_place_usecase.dart'; // <--- NUEVA IMPORTACIÓN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fb_auth.FirebaseAuth firebaseAuth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // AUTH DEPENDENCIES
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
  );
  final AuthLocalDataSource authLocalDataSource = AuthLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );
  final RegisterUserUseCase registerUserUseCase = RegisterUserUseCase(
    authRepository,
  );
  final LoginUserUseCase loginUserUseCase = LoginUserUseCase(authRepository);
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase(authRepository);

  // PLACE DEPENDENCIES
  final PlaceRemoteDataSource placeRemoteDataSource = PlaceRemoteDataSourceImpl(
    firestore: firebaseFirestore,
  );
  final PlaceRepository placeRepository = PlaceRepositoryImpl(
    remoteDataSource: placeRemoteDataSource,
  );
  final GetPlacesUseCase getPlacesUseCase = GetPlacesUseCase(placeRepository);
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase =
      GetPlacesByCategoryUseCase(placeRepository);
  final AddPlaceUseCase addPlaceUseCase = AddPlaceUseCase(placeRepository);

  runApp(
    MyApp(
      registerUserUseCase: registerUserUseCase,
      loginUserUseCase: loginUserUseCase,
      logoutUserUseCase: logoutUserUseCase,
      getPlacesUseCase: getPlacesUseCase,
      getPlacesByCategoryUseCase: getPlacesByCategoryUseCase,
      addPlaceUseCase: addPlaceUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;
  final GetPlacesUseCase getPlacesUseCase;
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;
  final AddPlaceUseCase addPlaceUseCase;

  const MyApp({
    super.key,
    required this.registerUserUseCase,
    required this.loginUserUseCase,
    required this.logoutUserUseCase,
    required this.getPlacesUseCase,
    required this.getPlacesByCategoryUseCase,
    required this.addPlaceUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) => AuthBloc(
                registerUserUseCase: registerUserUseCase,
                loginUserUseCase: loginUserUseCase,
                logoutUserUseCase: logoutUserUseCase,
              ),
        ),
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
        BlocProvider<PlaceBloc>(
          // <--- NUEVO BLOC PROVIDER
          create:
              (_) => PlaceBloc(
                getPlacesUseCase: getPlacesUseCase,
                getPlacesByCategoryUseCase: getPlacesByCategoryUseCase,
                addPlaceUseCase: addPlaceUseCase,
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Vive Huanchaco',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthSuccess) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
