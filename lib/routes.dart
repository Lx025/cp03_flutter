import 'package:cp_3/screens/intro_screen.dart';
import 'package:cp_3/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String intro = '/intro';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case intro:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota não encontrada!'))),
        );
    }
  }
}
