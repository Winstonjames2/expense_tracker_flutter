import 'package:finager/services/api_service.dart';

class StatsData {
  final double todayIncome;
  final double todayExpense;
  final double averageIncomeThisWeek;
  final double averageOutcomeThisWeek;
  final double totalSpent;
  final double dailyAverageIncomeThisMonth;
  final double exchangeRateMmkToUsdt;
  final double incomeThisMonth;
  final double outcomeThisMonth;

  StatsData({
    required this.todayIncome,
    required this.todayExpense,
    required this.averageIncomeThisWeek,
    required this.averageOutcomeThisWeek,
    required this.totalSpent,
    required this.dailyAverageIncomeThisMonth,
    required this.exchangeRateMmkToUsdt,
    required this.incomeThisMonth,
    required this.outcomeThisMonth,
  });
  factory StatsData.empty() => StatsData(
    todayIncome: 0,
    todayExpense: 0,
    averageIncomeThisWeek: 0,
    incomeThisMonth: 0,
    outcomeThisMonth: 0,
    averageOutcomeThisWeek: 0,
    totalSpent: 0,
    dailyAverageIncomeThisMonth: 0,
    exchangeRateMmkToUsdt: 0,
  );

  factory StatsData.fromJson(Map<String, dynamic> json) {
    return StatsData(
      todayIncome: json['today_income']?.toDouble() ?? 0.0,
      todayExpense: json['today_expense']?.toDouble() ?? 0.0,
      averageIncomeThisWeek:
          json['average_income_this_week']?.toDouble() ?? 0.0,
      averageOutcomeThisWeek:
          json['average_outcome_this_week']?.toDouble() ?? 0.0,
      totalSpent: json['total_spent']?.toDouble() ?? 0.0,
      dailyAverageIncomeThisMonth:
          json['daily_average_income_this_month']?.toDouble() ?? 0.0,
      exchangeRateMmkToUsdt:
          json['exchange_rate_mmk_to_usdt']?.toDouble() ?? 0.0,
      incomeThisMonth: json['income_this_month']?.toDouble() ?? 0.0,
      outcomeThisMonth: json['outcome_this_month']?.toDouble() ?? 0.0,
    );
  }
}

class StatsService {
  static Future<StatsData> fetchStats() async {
    final response = await ApiService.getRequest('stats');
    return StatsData.fromJson(response);
  }
}
