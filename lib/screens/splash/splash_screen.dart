import 'package:cp_3/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cp_3/data/repositories/settings_repository.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {

    await Future.delayed(const Duration(seconds: 3));


    if (!mounted) return;

    final settingsRepo = SettingsRepository();
    final bool showIntro = await settingsRepo.getShowIntro();

    if (showIntro) {
      Navigator.pushReplacementNamed(context, AppRoutes.intro);
    } else {
      // Verifica se está logado
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Lottie.asset(
          'assets/lottie/splash.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}