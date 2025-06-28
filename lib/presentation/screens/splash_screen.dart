import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/bloc/auth_bloc.dart';
import 'package:vive_huanchaco/presentation/auth/pages/login_screen.dart';
import 'package:vive_huanchaco/presentation/places/pages/home_screen.dart';
import 'package:vive_huanchaco/core/utils/app_colors.dart'; // Asegúrate de que esta ruta sea correcta

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Duración de la animación del logo
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Iniciar la animación y luego navegar
    _controller.forward().whenComplete(() {
      _navigateToNextScreen();
    });
  }

  // Ahora la navegación ocurre después de que la animación inicial del logo termina
  _navigateToNextScreen() async {
    // Puedes ajustar esta duración si necesitas un tiempo extra antes de navegar
    await Future.delayed(const Duration(milliseconds: 1500));

    // Asegúrate de que el widget aún está montado antes de navegar
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthSuccess) {
              return const HomeScreen();
            } else if (authState is AuthLoading) {
              // Muestra un indicador de carga mientras se verifica el estado de autenticación
              return const Scaffold(
                backgroundColor: AppColors.primaryColor,
                body: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            // Por defecto, si no es AuthSuccess ni AuthLoading (ej. AuthInitial, AuthError, etc.)
            return const LoginScreen();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación de FadeIn para el logo
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/icons/logo.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  // Muestra un icono de error si la imagen no carga
                  return const Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 100,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation, // También animamos el texto
              child: const Text(
                'Vive Huanchaco',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio adicional
            // Opcional: Un indicador de carga sutil si la autenticación tarda
            // Puedes decidir si mostrar esto solo después de la animación del logo o siempre.
            // if (_controller.isAnimating == false)
            //   const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}