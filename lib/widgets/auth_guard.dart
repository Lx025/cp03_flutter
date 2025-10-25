import 'package:cp_3/data/services/auth_service.dart';
import 'package:cp_3/routes.dart';
import 'package:cp_3/screens/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const SplashScreen();
        }


        if (snapshot.hasData) {
          return child;
        }


        return FutureBuilder(
          future: Future.microtask(() {

            if (ModalRoute.of(context)?.settings.name != AppRoutes.login) {
               Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          }),
   
          builder: (context, snapshot) => const SplashScreen(),
        );
      },
    );
  }
}