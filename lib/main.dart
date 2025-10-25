import 'package:cp_3/routes.dart';
import 'package:cp_3/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cp_3/firebase_options_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const cp_3());
}

class cp_3 extends StatelessWidget {
  const cp_3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeKey',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}