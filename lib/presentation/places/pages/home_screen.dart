// vive_huanchaco/lib/features/places/presentation/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/bloc/auth_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/pages/login_screen.dart';
import 'package:vive_huanchaco/core/utils/app_strings.dart';
import 'package:vive_huanchaco/presentation/places/bloc/navigation_bloc.dart';
import 'package:vive_huanchaco/shared/widgets/custom_navigation_drawer.dart';
import 'package:vive_huanchaco/core/utils/app_colors.dart';

// Importar pantallas placeholder para el Bottom Navigation
import 'package:vive_huanchaco/presentation/places/pages/favorite_places_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/main_home_content_screen.dart'; // Contenido del Home real
import 'package:vive_huanchaco/presentation/events/pages/events_screen.dart';

// Importar pantallas placeholder para el Navigation Drawer
import 'package:vive_huanchaco/presentation/places/pages/museums_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/hotels_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/restaurants_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/parks_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/beaches_screen.dart';
// --- NUEVAS IMPORTACIONES ---
import 'package:vive_huanchaco/presentation/places/pages/cafes_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/bars_screen.dart';
// import 'package:vive_huanchaco/presentation/settings/pages/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _bottomNavScreens = [
    const FavoritePlacesScreen(),
    const MainHomeContentScreen(),
    const EventsScreen(),
  ];

  final List<Widget> _drawerScreens = [
    // Las pantallas del drawer podrían ser las mismas que las de bottom nav o nuevas
    const MainHomeContentScreen(), // Default para el drawer, puedes cambiarlo
    const MuseumsScreen(),
    const HotelsScreen(),
    const RestaurantsScreen(),
    const ParksScreen(),
    const BeachesScreen(),
    const CafesScreen(),
    const BarsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoggedOut) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(authState.message)));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      builder: (context, authState) {
        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, navState) {
            int currentScreenIndex = navState.currentIndex;
            Widget currentBody = _bottomNavScreens[currentScreenIndex];
            String appBarTitle = AppStrings.appName; // Título por defecto

            if (navState is NavigationDrawerItemChanged) {
              currentBody = _drawerScreens[navState.drawerItemIndex];
              // Aquí podrías cambiar el título del AppBar según la sección del Drawer
              switch (navState.drawerItemIndex) {
                case 0: appBarTitle = 'Home'; break;
                case 1: appBarTitle = 'Museos'; break;
                case 2: appBarTitle = 'Hoteles';  break;
                case 3: appBarTitle = 'Restaurantes'; break;
                case 4: appBarTitle = 'Parques';  break;
                case 5: appBarTitle = 'Playas'; break;
                case 6: appBarTitle = 'Cafeterías'; break;
                case 7: appBarTitle = 'Bares';  break;
                default: appBarTitle = 'Home';  break;
              }
            } else if (navState is NavigationTabChanged) {
              switch (navState.currentIndex) {
                case 0: appBarTitle = 'Lugares Favoritos';  break;
                case 1: appBarTitle = 'Home'; break;
                case 2: appBarTitle = 'Experiencias y Eventos'; break;
                default:  appBarTitle = 'Home'; break;
              }
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(appBarTitle),
                backgroundColor: AppColors.primaryColor,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(LogoutUserEvent());
                    },
                  ),
                ],
              ),
              drawer: CustomNavigationDrawer(), // Nuestro Navigation Drawer
              body: currentBody, // Contenido de la pantalla actual
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navState.currentIndex,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  // Cuando se toca un ítem del Bottom Nav, despacha el evento
                  BlocProvider.of<NavigationBloc>(
                    context,
                  ).add(NavigateToTabEvent(index));
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: AppStrings.favoritePlacesTab,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: AppStrings.homeTab,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event),
                    label: AppStrings.eventsTab,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
