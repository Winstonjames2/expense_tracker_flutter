import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/payment_method.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/truck.dart';

class PreferencesService {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _fontSizeKey = 'fontSize';
  static const _fontFamilyKey = 'fontFamily';
  static const _accountDataKey = 'account';
  static const _paymentMethodDataKey = 'paymentMethod';
  static const _categoryDataKey = 'category';
  static const _truckDataKey = 'truck';

  Future<Map<String, String>> getLastUpdatedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, String>{};

    String? getLatestDate(String? jsonString) {
      if (jsonString == null) return null;
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        final dates =
            list
                .map(
                  (e) =>
                      DateTime.tryParse(e['updated_at'] ?? '') ??
                      DateTime(1970),
                )
                .toList();
        dates.sort((a, b) => b.compareTo(a));
        return dates.isNotEmpty ? dates.first.toIso8601String() : null;
      } catch (e) {
        debugPrint('Error parsing dates: $e');
        return null;
      }
    }

    final categoryRaw = prefs.getString(_categoryDataKey);
    final categoryDate = getLatestDate(categoryRaw);
    if (categoryDate != null) result['category'] = categoryDate;

    final paymentRaw = prefs.getString(_paymentMethodDataKey);
    final paymentDate = getLatestDate(paymentRaw);
    if (paymentDate != null) result['paymentMethod'] = paymentDate;

    final truckRaw = prefs.getString(_truckDataKey);
    final truckDate = getLatestDate(truckRaw);
    if (truckDate != null) result['truck'] = truckDate;
    return result;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_localeKey);
    return langCode != null ? Locale(langCode) : const Locale('my');
  }

  Future<void> saveFontsize(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, fontSize);
  }

  Future<double> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final fontSize = prefs.getDouble(_fontSizeKey);
    debugPrint('fontSize: $fontSize');
    return fontSize ?? 16;
  }

  Future<void> saveFontFamily(String fontFamily) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, fontFamily);
  }

  Future<String> loadFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    final fontFamily = prefs.getString(_fontFamilyKey);
    return fontFamily ?? 'Arial';
  }

  Future<void> saveAccountData(String accountData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountDataKey, accountData);
  }

  Future<List<Account>?> loadAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    final accountData = prefs.getString(_accountDataKey);
    if (accountData != null) {
      try {
        final List decoded = jsonDecode(accountData);
        return decoded
            .map((e) => Account.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error decoding account data: $e');
      }
    }
    return null;
  }

  Future<void> savePaymentMethodData(String paymentMethod) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_paymentMethodDataKey, paymentMethod);
  }

  Future<List<PaymentMethod>?> loadPaymentMethodData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_paymentMethodDataKey);
    if (rawJson != null) {
      try {
        final List decoded = jsonDecode(rawJson);
        return decoded
            .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error decoding payment methods: $e');
      }
    }
    return null;
  }

  Future<void> saveCategoryData(String categoryData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoryDataKey, categoryData);
  }

  Future<List<Category>?> loadCategoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_categoryDataKey);
    if (rawJson != null) {
      try {
        final List decoded = jsonDecode(rawJson);
        return decoded
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error decoding categories: $e');
      }
    }
    return null;
  }

  Future<void> saveTruckData(String trucksData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_truckDataKey, trucksData);
  }

  Future<List<Truck>?> loadTruckData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_truckDataKey);
    if (rawJson != null) {
      try {
        final List decoded = jsonDecode(rawJson);
        return decoded
            .map((e) => Truck.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint("Error Feching Truck Data: $e");
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username'),
      'displayName': prefs.getString('displayName') ?? 'Unknown',
      'profileImageUrl':
          prefs.getString('profileImageUrl') ??
          'https://placehold.co/100x100/png',
      'userId': prefs.getInt('userId'),
    };
  }
}
