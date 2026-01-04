import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

AnalyticsData getAnalyticsData(BuildContext context, WidgetRef ref) {
  final transactions = ref.watch(transactionDataProvider);
  double totalIncome = 0;
  double totalOutcome = 0;
  final dailySummary = <String, double>{};

  final incomeLabel = AppLocalizations.of(context)!.income;

  for (final tx in transactions.transactions) {
    final dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
    final amount = tx.amount;

    if (tx.transactionType == incomeLabel) {
      totalIncome += amount;
      dailySummary[dateKey] = (dailySummary[dateKey] ?? 0) + amount;
    } else {
      totalOutcome += amount;
      dailySummary[dateKey] = (dailySummary[dateKey] ?? 0) - amount;
    }
  }

  return AnalyticsData(
    totalIncome: totalIncome,
    totalOutcome: totalOutcome,
    dailySummary: dailySummary,
  );
}

class AnalyticsData {
  final double totalIncome;
  final double totalOutcome;
  final Map<String, double> dailySummary;

  AnalyticsData({
    required this.totalIncome,
    required this.totalOutcome,
    required this.dailySummary,
  });
}
