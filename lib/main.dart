import 'package:flutter/material.dart';
import 'package:project_11/doctor/dental_chart_screen.dart';
import 'package:project_11/patient/login_screen.dart';
import 'package:project_11/splash/onboard_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "Roboto",
      scaffoldBackgroundColor: const Color(0xFF0D1B3D),
    ),
    home: LoginScreen(),
  ),
);
