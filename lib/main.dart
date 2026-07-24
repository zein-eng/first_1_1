import 'package:first_1_1/patient/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_1_1/splash/onboard_page.dart';
import 'package:first_1_1/patient/login_screen.dart';
import 'package:first_1_1/splash/splash_page.dart';
import 'package:first_1_1/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await Constants.loadToken();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomeScreen() : const OnboardPage(),
    ),
  );
}