import 'dart:convert';
import 'dart:io';
import 'package:finager/services/preferences_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiService {
  // static const String baseUrl = 'https://';
  static const String baseUrl = 'http://10.0.2.2:8000';
  // static const String baseUrl = 'http://192.168.1.8:8000';

  // ---------------------- TOKEN UTILS ----------------------

  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> _saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  static Future<String> _getLangCode() async {
    final prefs = PreferencesService();
    return (await prefs.loadLocale()).languageCode;
  }

  // ---------------------- HEADERS ----------------------

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAccessToken();
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    headers['lang'] = await _getLangCode();

    return headers;
  }

  // ---------------------- REFRESH TOKEN ----------------------

  static Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final url = Uri.parse('$baseUrl/api/token/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];
      if (newAccessToken != null) {
        await _saveAccessToken(newAccessToken);
        return true;
      }
    }

    return false;
  }

  // ---------------------- WRAPPED REQUEST ----------------------
  static Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    http.Response response = await requestFn();

    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        response = await requestFn();
      }
    }

    return response;
  }

  // ---------------------- GET ----------------------

  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await _retryRequest(() async {
      final headers = await _getHeaders();
      return await http.get(url, headers: headers);
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  // ---------------------- POST ----------------------

  static Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint/');

    final response = await _retryRequest(() async {
      final headers = await _getHeaders();
      return await http.post(url, headers: headers, body: jsonEncode(data));
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception("Failed to add data");
    }
  }

  // ---------------------- PUT ----------------------

  static Future<dynamic> putRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint/');

    final response = await _retryRequest(() async {
      final headers = await _getHeaders();
      return await http.put(url, headers: headers, body: jsonEncode(data));
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to update data: ${response.body}");
    }
  }

  // ---------------------- PUT ----------------------

  static Future<dynamic> patchRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint/');

    final response = await _retryRequest(() async {
      final headers = await _getHeaders();
      return await http.patch(url, headers: headers, body: jsonEncode(data));
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update data: ${response.body}");
    }
  }

  // ---------------------- DELETE ----------------------

  static Future<dynamic> deleteRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint/');

    final response = await _retryRequest(() async {
      final headers = await _getHeaders();
      return await http.delete(url, headers: headers);
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete data: ${response.body}");
    }
  }

  // ---------------------- UPLOAD FILE ----------------------
  static Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/api/upload-image/');
    final token = await _getAccessToken();
    final headers = {'Authorization': 'Bearer $token'};

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mediaType = MediaType.parse(mimeType);

    final request =
        http.MultipartRequest('POST', url)
          ..headers.addAll(headers)
          ..files.add(
            await http.MultipartFile.fromPath(
              'image',
              imageFile.path,
              contentType: mediaType,
              filename: basename(imageFile.path),
            ),
          );

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['image_url'];
    } else {
      throw Exception("Failed to upload image: ${response.body}");
    }
  }
}
