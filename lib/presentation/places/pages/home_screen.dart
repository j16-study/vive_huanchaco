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

// --- NUEVA IMPORTACIÓN ---
import 'package:vive_huanchaco/presentation/places/pages/category_places_screen.dart';

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

  // --- LISTA ACTUALIZADA PARA USAR LA NUEVA PANTALLA REUTILIZABLE ---
  final List<Widget> _drawerScreens = [
    const MainHomeContentScreen(),
    const CategoryPlacesScreen(category: "Museos"),
    const CategoryPlacesScreen(category: "Hoteles"),
    const CategoryPlacesScreen(category: "Restaurantes"),
    const CategoryPlacesScreen(category: "Cafeterías"),
    const CategoryPlacesScreen(category: "Parques"),
    const CategoryPlacesScreen(category: "Playas"),
    const CategoryPlacesScreen(category: "Bares"),
    const CategoryPlacesScreen(category: "Bancos"),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoggedOut) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.message)),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.message), backgroundColor: AppColors.errorColor),
          );
        }
      },
      builder: (context, authState) {
        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, navState) {
            int currentScreenIndex = navState.currentIndex;
            Widget currentBody = _bottomNavScreens[currentScreenIndex];
            String appBarTitle = AppStrings.appName;

            if (navState is NavigationDrawerItemChanged) {
              currentBody = _drawerScreens[navState.drawerItemIndex];
              // --- TÍTULOS ACTUALIZADOS ---
              switch (navState.drawerItemIndex) {
                case 0: appBarTitle = 'Home'; break;
                case 1: appBarTitle = 'Museos'; break;
                case 2: appBarTitle = 'Hoteles'; break;
                case 3: appBarTitle = 'Restaurantes'; break;
                case 4: appBarTitle = 'Cafeterías'; break;
                case 5: appBarTitle = 'Parques'; break;
                case 6: appBarTitle = 'Playas'; break;
                case 7: appBarTitle = 'Bares'; break;
                case 8: appBarTitle = 'Bancos'; break;
                default: appBarTitle = 'Home'; break;
              }
            } else if (navState is NavigationTabChanged) {
                switch (navState.currentIndex) {
                  case 0: appBarTitle = 'Lugares Favoritos'; break;
                  case 1: appBarTitle = 'Home'; break;
                  case 2: appBarTitle = 'Experiencias y Eventos'; break;
                  default: appBarTitle = 'Home'; break;
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
              drawer: const CustomNavigationDrawer(),
              body: currentBody,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navState.currentIndex,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  BlocProvider.of<NavigationBloc>(context).add(NavigateToTabEvent(index));
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