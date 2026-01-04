import 'package:finager/components/date_field.dart';
import 'package:finager/components/delete_dispatch_button.dart';
import 'package:finager/components/driver_field.dart';
import 'package:finager/components/global_loader.dart';
import 'package:finager/components/truck_dropdown.dart';
import 'package:finager/models/dispatch_data.dart';
import 'package:finager/models/truck.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/screens/transaction_history/transaction_query_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

const kSummaryTextColor = Colors.white;
const kIncomeColor = Colors.greenAccent;
const kExpenseColor = Colors.orangeAccent;
const kRevenuePositiveColor = Colors.green;
const kRevenueNegativeColor = Colors.red;
const kBackgroundColor = Colors.blueGrey;

class DetailSummary extends ConsumerWidget {
  final DispatchData dispatching;
  final bool isActiveDispatch;

  const DetailSummary({
    super.key,
    required this.dispatching,
    this.isActiveDispatch = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trucks = ref.read(appDataProvider).trucks;

    final appLocal = AppLocalizations.of(context)!;
    final revenue =
        (dispatching.totalRevenue ?? 0) - (dispatching.totalCost ?? 0);
    final isNegative = revenue < 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            color: Colors.blueGrey.shade700,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(context, appLocal, isWide, trucks),
              const SizedBox(height: 10),
              _infoRow(context, ref, appLocal),
              const SizedBox(height: 14),
              _summaryRow(appLocal, revenue, isNegative, isWide),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isActiveDispatch
                            ? Colors.indigoAccent.withAlpha(220)
                            : Colors.grey.withAlpha(220),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: Text(
                              style: TextStyle(
                                color:
                                    isActiveDispatch
                                        ? Colors.redAccent
                                        : Colors.indigoAccent,
                              ),
                              isActiveDispatch
                                  ? appLocal.confirmInactivate
                                  : appLocal.confirmActivate,
                            ),
                            content: Text(
                              isActiveDispatch
                                  ? appLocal.areYouSureToInactivate
                                  : appLocal.areYouSureToActivate,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  appLocal.cancel,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  backgroundColor: Colors.indigoAccent
                                      .withAlpha(220),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(appLocal.confirm),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      if (isActiveDispatch) {
                        await ref
                            .read(transactionFormProvider.notifier)
                            .convertDispatchMode(dispatching.id, false);
                      } else {
                        await ref
                            .read(transactionFormProvider.notifier)
                            .convertDispatchMode(dispatching.id, true);
                      }
                    }
                  },
                  child: Text(
                    isActiveDispatch
                        ? appLocal.dispatchActive
                        : appLocal.dispatchInactive,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _topRow(
    BuildContext context,
    AppLocalizations appLocal,
    bool isWide,
    trucks,
  ) {
    final truckName =
        trucks
            .firstWhere(
              (truck) => truck.id == dispatching.truck['id'],
              orElse: () => Truck(id: 0, name: 'Error', imei: ''),
            )
            .name;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${appLocal.truck}: $truckName',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.yellowAccent.shade200,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          dispatching.dispatchingDate != null
              ? "${appLocal.date}: ${dispatching.dispatchingDate!.day}/${dispatching.dispatchingDate!.month}/${dispatching.dispatchingDate!.year}"
              : appLocal.noDate,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: kSummaryTextColor.withAlpha(220),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations appLocal,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "${appLocal.driverName}: ${dispatching.driver ?? appLocal.unknown}",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
          onPressed: () {
            _showEditDialog(context, ref, appLocal);
          },
          icon: const Icon(Icons.edit, size: 16),
          label: Text(appLocal.edit),
        ),
      ],
    );
  }

  Widget _summaryRow(
    AppLocalizations appLocal,
    double revenue,
    bool isNegative,
    bool isWide,
  ) {
    final colorRevenue = isNegative ? kExpenseColor : kIncomeColor;

    final amounts = [
      _amountBox(appLocal.income, dispatching.totalRevenue ?? 0, kIncomeColor),
      _amountBox(appLocal.expense, dispatching.totalCost ?? 0, kExpenseColor),
      _amountBox(appLocal.revenue, revenue, colorRevenue),
    ];

    return isWide
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: amounts,
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              amounts
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: e,
                    ),
                  )
                  .toList(),
        );
  }

  Widget _amountBox(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color.withAlpha(220),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${value.toStringAsFixed(0)} Ks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations appLocal,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final notifier = ref.read(transactionFormProvider.notifier);
            final isLoading = ref.watch(transactionFormProvider).isSendingData;
            final schemeColor = Theme.of(context).colorScheme.tertiary;

            return AlertDialog(
              title: Text(
                appLocal.edit,
                style: TextStyle(
                  color: schemeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateField(initialDate: dispatching.dispatchingDate),
                    const SizedBox(height: 16),
                    TruckDropdown(initialTruck: dispatching.truck),
                    const SizedBox(height: 16),
                    DriverField(initialDriver: dispatching.driver),
                    const SizedBox(height: 32),
                    DeleteButton(
                      dispatchId: dispatching.id,
                      onDeleted: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    appLocal.cancel,
                    style: TextStyle(color: schemeColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(150, 10),
                    backgroundColor: Colors.indigoAccent.withAlpha(220),
                  ),
                  onPressed: () async {
                    GlobalLoader.show(context);
                    notifier.setSendingData(true);
                    final res = await notifier.saveDispatchDataChanges(
                      dispatching,
                    );

                    switch (res) {
                      case SaveStatus.noChanges:
                        showMessage(
                          ref: ref,
                          text: appLocal.noChangesMade,
                          icon: Icons.info,
                          backgroundColor: Colors.amber,
                        );
                        break;
                      case SaveStatus.failure:
                        showMessage(
                          ref: ref,
                          text: appLocal.failedToUpdateChanges,
                          icon: Icons.error,
                          backgroundColor: Colors.red,
                        );
                        break;
                      case SaveStatus.success:
                        if (context.mounted) Navigator.pop(context);
                        showMessage(
                          ref: ref,
                          text: appLocal.successfullyUpdatedChanges,
                          icon: Icons.check,
                          backgroundColor: Colors.green,
                        );

                        await TransactionQueryService()
                            .fetchDispatchTransactionData(
                              ref: ref,
                              dispatchId: dispatching.id,
                            );
                        break;
                    }
                    GlobalLoader.hide();
                    notifier.setSendingData(false);
                  },
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            appLocal.saveChanges,
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
