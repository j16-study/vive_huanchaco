// vive_huanchaco/lib/shared/widgets/custom_navigation_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vive_huanchaco/core/utils/app_colors.dart';
import 'package:vive_huanchaco/core/utils/app_strings.dart';
import 'package:vive_huanchaco/presentation/places/bloc/navigation_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/bloc/auth_bloc.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/logo.png', height: 60), // Asegúrate de tener tu logo aquí
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthSuccess) {
                      return Text(
                        state.user.email ?? 'Usuario Trux',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const Text(
                      'Invitado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, 0, Icons.home, AppStrings.homeTab), // Home también en el drawer
          _buildDrawerItem(context, 1, Icons.museum, AppStrings.museums),
          _buildDrawerItem(context, 2, Icons.hotel, AppStrings.hotels),
          _buildDrawerItem(context, 3, Icons.restaurant, AppStrings.restaurants),
          _buildDrawerItem(context, 4, Icons.park, AppStrings.parks),
          _buildDrawerItem(context, 5, Icons.beach_access, AppStrings.beaches),
          _buildDrawerItem(context, 6, Icons.shopping_cart, AppStrings.shoppingMalls),
          _buildDrawerItem(context, 7, FontAwesomeIcons.buildingColumns, AppStrings.banks), // Icono de banco
          const Divider(),
          _buildDrawerItem(context, -1, Icons.settings, AppStrings.settings), // Ajustes
          _buildDrawerItem(context, -2, Icons.logout, AppStrings.logoutButton, isLogout: true), // Cerrar sesión
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, int index, IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        if (isLogout) {
          BlocProvider.of<AuthBloc>(context).add(LogoutUserEvent());
        } else if (index == -1) {
          // Lógica para ir a la pantalla de Ajustes (aún no creada)
          print('Navegar a Ajustes');
        } else {
          BlocProvider.of<NavigationBloc>(context).add(NavigateToDrawerItemEvent(index));
        }
      },
    );
  }
}