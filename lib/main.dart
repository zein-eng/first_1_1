
import 'package:first_1_1/splash/Onboard_page.dart';
import 'package:flutter/material.dart';
import 'package:first_1_1/patient/profile_screen.dart';
void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 
  @override
     
  Widget build(BuildContext context) {

      return  MaterialApp(
    debugShowCheckedModeBanner: false,
      home: PatientProfilePage(),
    );
    }}
