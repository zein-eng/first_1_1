import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

enum UserRole { patient, doctor }

class Constants {
  static const String baseUrl = 'http://172.21.32.1:8000/api/';
  static const Color appColor = Color(0xFF011D34);
  static String token = '';
  static Dio dio = Dio();

  /// الصور القادمة من الباك اند (زي profile_image) بترجع كمسار نسبي
  /// من مجلد storage، مثلاً "profiles/xxx.jpg" - هاي الدالة
  /// بتبني الرابط الكامل: http://<السيرفر>/storage/profiles/xxx.jpg
  static String get storageBaseUrl {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.authority}/storage/';
  }

  /// بتاخد أي قيمة صورة راجعة من السيرفر وترجع رابط كامل قابل للعرض.
  /// إذا كانت أصلاً رابط كامل (http/https) بترجعها متل ما هي.
  static String resolveImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // بنشيل أي / زيادة بالبداية عشان ما يصير سلاش مزدوج
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$storageBaseUrl$cleanPath';
  }

  static const String _tokenKey = 'auth_token';
  static Future<void> saveToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, newToken);
  }

  static Future<bool> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    if (savedToken != null && savedToken.isNotEmpty) {
      token = savedToken;
      return true;
    }
    return false;
  }
  static Future<void> clearToken() async {
    token = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> logout() async {
    try {
      await dio.post(
        '${baseUrl}patient/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    } finally {
      await clearToken();
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      print('==== TOKEN BEING SENT: "$token" ====');
      final response = await dio.get(
        '${baseUrl}patient/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      print('==== PROFILE API RESPONSE: ${response.data} ====');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return null;
  }

  static Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? dateOfBirth, // بصيغة yyyy-MM-dd
    Uint8List? imageBytes, // بايتات الصورة (تشتغل ويب + موبايل)
    String? imageFilename,
  }) async {
    try {
      final String currentToken = token;

      var uri = Uri.parse('${baseUrl}patient/update-profile');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $currentToken',
        'Accept': 'application/json',
      });

      // كل الحقول "sometimes" بالباك اند، يعني منرسل بس يلي فعلاً معبّى
      if (firstName != null && firstName.isNotEmpty) {
        request.fields['first_name'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        request.fields['last_name'] = lastName;
      }
      if (phone != null && phone.isNotEmpty) {
        request.fields['phone'] = phone;
      }
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        request.fields['date_of_birth'] = dateOfBirth;
      }

      // MultipartFile.fromBytes بتشتغل عالويب والموبايل، عكس fromPath
      // اللي بيحتاج dart:io وما بيشتغل عالويب إطلاقاً
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            imageBytes,
            filename: imageFilename ?? 'profile_image.jpg',
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }
}