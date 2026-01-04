import 'package:finager/models/dispatch_data.dart';
import 'package:finager/models/truck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:finager/l10n/app_localizations.dart';

class DispatchCard extends ConsumerWidget {
  final DispatchData dispatch;

  const DispatchCard({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    final trucks = ref.read(appDataProvider).trucks;

    final textTheme = Theme.of(context).textTheme;
    final double income = dispatch.totalRevenue ?? 0;
    final double expense = dispatch.totalCost ?? 0;
    final double revenue = income - expense;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.indigoAccent.withAlpha(160),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${appLocal.id}: ${dispatch.id}',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dispatch.dispatchingDate != null
                      ? "${dispatch.dispatchingDate!.day}/${dispatch.dispatchingDate!.month}/${dispatch.dispatchingDate!.year}"
                      : appLocal.noDate,
                  style: textTheme.titleSmall?.copyWith(color: Colors.white70),
                ),
                Text(
                  trucks
                      .firstWhere(
                        (truck) => truck.id == dispatch.truck['id'],
                        orElse: () => Truck(id: 0, name: 'Error', imei: ''),
                      )
                      .name,
                  style: textTheme.displayMedium?.copyWith(
                    color: Colors.yellow.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Income/Expense/Revenue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFinanceColumn(
                  appLocal.income,
                  "+${income.toStringAsFixed(0)} Ks",
                  Colors.greenAccent,
                  textTheme,
                ),
                _buildFinanceColumn(
                  appLocal.expense,
                  "-${expense.toStringAsFixed(0)} Ks",
                  Colors.orangeAccent.withAlpha(220),
                  textTheme,
                ),
                _buildFinanceColumn(
                  appLocal.revenue,
                  "${revenue >= 0 ? "+" : "-"}${revenue.abs().toStringAsFixed(0)} Ks",
                  revenue >= 0 ? Colors.lightGreenAccent : Colors.redAccent,
                  textTheme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Driver info
            Text(
              "${appLocal.driverName}: ${dispatch.driver ?? appLocal.unknown}",
              style: textTheme.labelMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            // View Details button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    'dispatch-detail',
                    pathParameters: {'id': dispatch.id.toString()},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_outward_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  appLocal.viewDetail,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceColumn(
    String label,
    String value,
    Color color,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: Colors.white)),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
