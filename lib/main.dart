import 'package:flutter/material.dart';
import 'package:gym_app/screens/home.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/register.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/services/theme.dart';
import 'package:gym_app/view_models/auth_model.dart';
import 'package:gym_app/themes/dark.dart';
import 'package:gym_app/themes/light.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = serviceLocator<ThemeService>();
    final authVM = serviceLocator<AuthViewModel>();

    return FutureBuilder(
      future: authVM.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return AnimatedBuilder(
          animation: Listenable.merge([themeService, authVM.isLoggedIn]),
          builder: (_, __) {
            return MaterialApp(
              title: 'Gym App',
              theme: lightMode,
              darkTheme: darkMode,
              themeMode: themeService.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: authVM.isLoggedIn.value ? Home() : Login(),
              routes: {
                '/login': (_) => Login(),
                '/register': (_) => Register(),
                '/home': (_) => Home(),
              },
            );
          },
        );
      },
    );
  }
}
