import 'package:flutter/material.dart';
import 'package:cp_3/screens/splash/splash_screen.dart';
import 'package:cp_3/screens/intro/intro_screen.dart';
import 'package:cp_3/screens/login/login_screen.dart';
import 'package:cp_3/screens/home/home_screen.dart';
import 'package:cp_3/screens/new_password/new_password_screen.dart';
import 'package:cp_3/widgets/auth_guard.dart';

class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String home = '/home';
  static const String newPassword = '/new-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case intro:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: HomeScreen()),
        );
      case newPassword:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: NewPasswordScreen()),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}