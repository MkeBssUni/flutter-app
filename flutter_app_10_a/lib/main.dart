import 'package:flutter/material.dart';
import 'package:flutter_app_10_a/view_models/auth_viewmodel.dart';
import 'package:flutter_app_10_a/views/home_screen.dart';
import 'package:flutter_app_10_a/views/login_screen.dart';
import 'package:flutter_app_10_a/views/register_screen.dart';
import 'package:flutter_app_10_a/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mi app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
            useMaterial3: true,
          ),
          routes: {
            '/': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
          },
          initialRoute: '/splash'
          )
    );
  }
}
