import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/bloc/auth_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/pages/login_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/home_screen.dart';
import 'package:vive_huanchaco/core/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 10000), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocBuilder<AuthBloc, AuthState>(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Asegúrate de tener tu logo en la ruta 'assets/images/logo.png'
            Image.asset('assets/images/logo.png', height: 150),
            const SizedBox(height: 20),
            const Text(
              'Vive Huanchaco',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}