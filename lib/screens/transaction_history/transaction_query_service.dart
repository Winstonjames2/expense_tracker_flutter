import 'dart:async';
import 'package:finager/models/dispatch_data.dart';
import 'package:finager/screens/dispatch/dispatchDetail/dispatch_detail_screen.dart';
import 'package:finager/services/api_service.dart';
import 'package:finager/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionQueryService {
  Future<void> fetchDispatchTransactionData({
    required WidgetRef ref,
    required int? dispatchId,
  }) async {
    final res = await fetchTransaction(truckDispatchingId: dispatchId);
    final transactions = res['data'];
    if (transactions is List<Transaction>) {
      ref
          .read(dispatchTransactionProvider.notifier)
          .setTransactions(transactions);
    }
  }

  Future<Map<String, dynamic>> fetchTransaction({
    DateTime? fromDate,
    DateTime? toDate,
    int? categoryId,
    int? truckDispatchingId,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        if (fromDate != null)
          'start_date': fromDate.toIso8601String().split('T').first,
        if (toDate != null)
          'end_date': toDate.toIso8601String().split('T').first,
        if (categoryId != null) 'category': '$categoryId',
        if (truckDispatchingId != null)
          'truck_dispatching': '$truckDispatchingId',
        'page': '$page',
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final decodedJson = await ApiService.getRequest(
        'api/transaction/?$queryString',
      );
      final data = decodedJson['results'];

      final hasMore = decodedJson['has_next'] as bool? ?? false;

      if (data is! List) {
        throw Exception('Unexpected response format: not a List');
      }

      final decodedTransactions =
          data
              .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
              .toList();
      return {"data": decodedTransactions, "hasMore": hasMore};
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Transaction Fetch Error', stackTrace: stackTrace);
      debugPrint('Error fetching transactions: $e');
    }
    return {"data": [], "hasMore": false};
  }

  Future<Map<String, dynamic>> fetchDispatching({int page = 1}) async {
    try {
      final decodedJson = await ApiService.getRequest(
        'api/truck-dispatch/?page=$page',
      );
      final data = decodedJson['results'];
      final hasMore = decodedJson['has_next'] as bool? ?? false;
      if (data is! List) {
        throw Exception('Unexpected response format: not a List');
      }
      final decodedDispatching =
          data
              .map(
                (json) => DispatchData.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      return {"data": decodedDispatching, "hasMore": hasMore};
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Dispatching Fetch Error', stackTrace: stackTrace);
      debugPrint('Error fetching dispatching: $e');
    }
    return {"data": [], "hasMore": false};
  }
}
