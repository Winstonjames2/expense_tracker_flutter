import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/providers/category_analytics_provider.dart';
import 'package:finager/widgets/pie_chart_widget.dart';
import 'package:finager/l10n/app_localizations.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    final householdAnalytics = ref.watch(
      categoryAnalyticsProvider(
        CategoryAnalyticsArgs(isHouseExpense: true, outcomeLabel: 'Outcome'),
      ),
    );

    final truckAnalytics = ref.watch(
      categoryAnalyticsProvider(
        CategoryAnalyticsArgs(isHouseExpense: false, outcomeLabel: 'Outcome'),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocal.expenseAnalytics,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent.withAlpha(220),
      ),
      body: ListView(
        children: [
          CategoryPieChart(
            analytics: householdAnalytics,
            title: appLocal.householdExpenses,
          ),

          CategoryPieChart(
            analytics: truckAnalytics,
            title: appLocal.truckExpenses,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
