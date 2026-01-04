import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finager/services/api_service.dart';

class AuthService {
  // login send function
  Future<Map<String, dynamic>> loginService(
    Map<String, dynamic> loginData,
  ) async {
    try {
      final decodedData = await ApiService.postRequest('api/login', loginData);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', decodedData['accessToken']);
      await prefs.setString('refreshToken', decodedData['refreshToken']);
      await prefs.setString('username', decodedData['username']);
      await prefs.setInt('userId', decodedData['userId']);
      await prefs.setString(
        'displayName',
        (decodedData['displayName'] != null &&
                decodedData['displayName'].toString().trim().isNotEmpty)
            ? decodedData['displayName']
            : 'Unknown',
      );
      await prefs.setString(
        'profileImageUrl',
        decodedData['profileImageUrl'] ??
            'https://www.gravatar.com/avatar/placeholder?d=mp&s=200',
      );
      return decodedData;
    } catch (e) {
      debugPrint("error: $e");
      return {'success': false};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('username');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String> updateProfileImage(pickedFile) async {
    return await ApiService.uploadImage(pickedFile);
  }

  Future<void> updateDisplayName(String displayName) async {
    await ApiService.patchRequest('api/update-profile', {
      "displayName": displayName,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', displayName);
  }
}
