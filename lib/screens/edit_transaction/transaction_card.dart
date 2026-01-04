import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:finager/models/transaction.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction? tx;

  const TransactionCard({super.key, this.tx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIncome = tx?.transactionType == "Income";
    final color =
        isIncome == true ? Colors.green.shade600 : Colors.red.shade600;
    final hasTruck = tx?.truckDispatching != null;

    final cardColor =
        isDark ? const Color.fromARGB(255, 55, 69, 103) : Colors.white;
    final bgOverlayColor = Colors.indigo.withAlpha(isDark ? 25 : 20);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Stack(
        children: [
          if (hasTruck)
            Positioned.fill(
              left: 0,
              right: MediaQuery.of(context).size.width * 0.56,
              child: Container(
                decoration: BoxDecoration(
                  color: bgOverlayColor,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/icon/truck-128x128.png'),
                    fit: BoxFit.cover,
                    opacity: 0.08,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildContent(context, ref, theme, color, hasTruck, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Color amountColor,
    bool hasTruck,
    bool isDark,
  ) {
    final tx = this.tx!;
    final titleColor = isDark ? Colors.indigo.shade100 : Colors.indigo.shade900;
    final descriptionColor = isDark ? Colors.grey.shade300 : Colors.black87;
    final labelColor = isDark ? Colors.grey.shade400 : Colors.black54;
    final truckColor = isDark ? Colors.indigo.shade200 : Colors.indigo.shade700;
    final buttonTextColor =
        isDark ? Colors.indigo.shade100 : Colors.indigo.shade900;
    final buttonBorderColor =
        isDark ? Colors.indigo.shade300 : Colors.indigo.shade600;
    final buttonBgColor = Colors.indigoAccent.withAlpha(isDark ? 60 : 40);

    final appData = ref.read(appDataProvider);

    final currentCat =
        appData.categories.where((cat) => cat.id == tx.category).firstOrNull;
    final currentPayment =
        appData.paymentMethods
            .where((pm) => pm.id == tx.paymentMethod)
            .firstOrNull;
    final currentTruck =
        appData.trucks
            .where((truck) => truck.id == tx.truckDispatching?['truck'])
            .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Amount
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "#${tx.id} - ${currentCat?.name ?? 'Unknown'}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "${tx.transactionType == "Income" ? '+' : '-'}${tx.amount.toStringAsFixed(2)}",
              style: theme.textTheme.titleMedium!.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        if (tx.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              tx.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(
                color: descriptionColor,
              ),
            ),
          ),

        /// Payment method + date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentPayment != null)
              Flexible(
                child: Text(
                  "${AppLocalizations.of(context)!.paymentMethod}: ${currentPayment.name}",
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: labelColor,
                  ),
                ),
              ),
            const Spacer(),
            Text(
              hasTruck
                  ? DateFormat('d/MM/y HH:mm').format(tx.date)
                  : DateFormat('d/MM/y').format(tx.date),
              style: theme.textTheme.labelSmall!.copyWith(color: labelColor),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// Truck + Edit Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasTruck)
              Flexible(
                child: Text(
                  "${AppLocalizations.of(context)!.truck}: ${currentTruck?.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: truckColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBgColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: buttonBorderColor, width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onPressed:
                  () => context.pushNamed('transaction-detail', extra: tx),
              icon: const Icon(Icons.edit, size: 16),
              label: Text(
                AppLocalizations.of(context)!.edit,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: buttonTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
