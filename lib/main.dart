import 'package:flutter/material.dart';
import 'package:gym_app/screens/home.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/register.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (_) => const Home(),
        "/register": (_) => const Register(),
        "/login": (_) => const Login(),
      },
    ),
  );
}
