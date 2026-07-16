import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum UserRole { patient, doctor }

class Constants {
  static const String baseUrl = 'http://10.105.88.40:8000/api/';
  static const Color appColor = Color(0xFF011D34);
  static String token = '';
  static Dio dio = Dio();
}
