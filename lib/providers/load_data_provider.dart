import 'dart:convert';
import 'package:finager/models/category.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/stats_provider.dart';
import 'package:finager/services/api_service.dart';
import 'package:finager/models/account.dart';
import 'package:finager/models/payment_method.dart';
import 'package:finager/models/truck.dart';
import 'package:flutter/material.dart';
import 'package:finager/services/preferences_service.dart';

class LoadDataProvider {
  final _prefs = PreferencesService();

  Future<bool> needUpdatingData() async {
    final Map<String, dynamic> backendVersion = await ApiService.getRequest(
      'version/',
    );
    final localVersion = await _prefs.getLastUpdatedDates();
    // Normalize keys to lowercase
    final normalizedBackend = backendVersion.map(
      (k, v) => MapEntry(k.toLowerCase(), v),
    );
    final normalizedLocal = localVersion.map(
      (k, v) => MapEntry(k.toLowerCase(), v),
    );
    for (final entry in normalizedBackend.entries) {
      final model = entry.key;
      final backendTimeStr = entry.value;
      final localTimeStr = normalizedLocal[model];

      final backendTime =
          backendTimeStr != null ? DateTime.tryParse(backendTimeStr) : null;
      final localTime =
          localTimeStr != null ? DateTime.tryParse(localTimeStr) : null;
      if (backendTime == null) continue;

      final backendTrunc = DateTime.utc(
        backendTime.year,
        backendTime.month,
        backendTime.day,
        backendTime.hour,
        backendTime.minute,
        backendTime.second,
      );

      final localTrunc =
          localTime != null
              ? DateTime.utc(
                localTime.year,
                localTime.month,
                localTime.day,
                localTime.hour,
                localTime.minute,
                localTime.second,
              )
              : null;
      final needsUpdate =
          localTrunc == null || backendTrunc.isAfter(localTrunc);
      if (needsUpdate) {
        return true;
      }
    }

    return false;
  }

  // Fetch accounts
  Future<List<Account>> fetchAccounts() async {
    try {
      final decodedJson = await ApiService.getRequest('api/account/');
      if (decodedJson is! List) {
        throw Exception('Unexpected response format: not a List');
      }
      final decodedAccounts =
          decodedJson
              .map((json) => Account.fromJson(json as Map<String, dynamic>))
              .toList();
      await _prefs.saveAccountData(jsonEncode(decodedAccounts));
      return decodedAccounts;
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Accounts Fetch Error', stackTrace: stackTrace);
      debugPrint('Error fetching accounts: $e');
    }
    return [];
  }

  Future<StatsData?> fetchStatsData() async {
    final statsData = await StatsService.fetchStats();
    return statsData;
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final decodedJson = await ApiService.getRequest('api/category');
      if (decodedJson is! List) {
        throw Exception('Unexpected response format: not a List');
      }
      final decodedCategories =
          decodedJson
              .map((json) => Category.fromJson(json as Map<String, dynamic>))
              .toList();
      await _prefs.saveCategoryData(jsonEncode(decodedCategories));
      return decodedCategories;
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Categories Fetch Error', stackTrace: stackTrace);
      debugPrint('Error fetching categories: $e');
    }
    return [];
  }

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    try {
      final decodedJson = await ApiService.getRequest('api/payment-method');
      if (decodedJson is! List) {
        throw Exception('Unexpected response format: not a List');
      }
      final decodedPaymentMethods =
          decodedJson
              .map(
                (json) => PaymentMethod.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      await _prefs.savePaymentMethodData(jsonEncode(decodedPaymentMethods));
      return decodedPaymentMethods;
    } catch (e, stackTrace) {
      debugPrintStack(
        label: 'Payment Methods Fetch Error',
        stackTrace: stackTrace,
      );
      debugPrint('Error fetching payment methods: $e');
    }
    return [];
  }

  Future<List<Truck>> fetchTrucks() async {
    try {
      final decodedJson = await ApiService.getRequest('api/truck');
      if (decodedJson is! List) {
        throw Exception('Unexpected response format: not a List');
      }
      final decodedTrucks =
          decodedJson
              .map((json) => Truck.fromJson(json as Map<String, dynamic>))
              .toList();
      await _prefs.saveTruckData(jsonEncode(decodedTrucks));
      return decodedTrucks;
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Trucks Fetch Error', stackTrace: stackTrace);
      debugPrint('Error fetching trucks: $e');
    }
    return [];
  }

  Future<bool> addModel(String path, Map<String, dynamic> data, ref) async {
    try {
      final res = await ApiService.postRequest('api/$path', data);
      if (res['status'] == 200) {
        return true;
      }
      showMessage(ref: ref, text: res['error']);
      return false;
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Add Model Error', stackTrace: stackTrace);
      debugPrint('Error adding model: $e');
      return false;
    }
  }

  Future<bool> updateModel(
    String path,
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiService.patchRequest('api/$path/$id', data);
      if (res) {
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Update Model Error', stackTrace: stackTrace);
      debugPrint('Error updating model: $e');
      return false;
    }
  }

  Future<bool> deleteModel(String path, int id) async {
    try {
      return await ApiService.deleteRequest('api/$path/$id');
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Delete Model Error', stackTrace: stackTrace);
      debugPrint('Error deleting model: $e');
      return false;
    }
  }

  Future<bool> recalculateAllTransactions() async {
    try {
      final res = await ApiService.getRequest(
        'api/account_balance_recalculate',
      );
      if (res['status'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      debugPrintStack(
        label: 'Recalculate Transactions Error',
        stackTrace: stackTrace,
      );
      debugPrint('Error recalculating transactions: $e');
    }
    return false;
  }
}
