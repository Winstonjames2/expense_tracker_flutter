import 'package:finager/providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/widgets/stats_card_widget.dart';
import 'package:finager/l10n/app_localizations.dart';

class StatsScreen extends ConsumerWidget {
  final StatsData statsData;
  const StatsScreen({super.key, required this.statsData});
  String mmkFormat(num? value) => '${value!.toStringAsFixed(2)} Ks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),

      children: [
        StatCard(
          label: appLocal.weeklyAverageIncome,
          value: mmkFormat(statsData.averageIncomeThisWeek),
          icon: Icons.trending_up,
          color: Colors.green,
        ),
        StatCard(
          label: appLocal.weeklyAverageOutcome,
          value: mmkFormat(statsData.averageOutcomeThisWeek),
          icon: Icons.trending_down,
          color: Colors.red,
        ),
        StatCard(
          label: appLocal.totalSpent,
          value: mmkFormat(statsData.totalSpent),
          icon: Icons.account_balance_wallet_outlined,
          color: Colors.orange,
        ),
        StatCard(
          label: appLocal.thisMonthDailyAverageIncome,
          value: mmkFormat(statsData.dailyAverageIncomeThisMonth),
          icon: Icons.calendar_today,
          color: Colors.teal,
        ),
        StatCard(
          label: appLocal.exchangeRate,
          value: '1 USDT = ${statsData.exchangeRateMmkToUsdt} MMK',
          icon: Icons.attach_money,
          color: Colors.pink,
        ),
      ],
    );
  }
}
