import 'package:finager/components/global_loader.dart';
import 'package:finager/models/truck.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:finager/l10n/app_localizations.dart';

class ActiveTruckDispatch extends ConsumerStatefulWidget {
  const ActiveTruckDispatch({super.key});

  @override
  ConsumerState<ActiveTruckDispatch> createState() =>
      _ActiveTruckDispatchState();
}

class _ActiveTruckDispatchState extends ConsumerState<ActiveTruckDispatch> {
  @override
  void initState() {
    super.initState();
    if (ref.read(transactionDataProvider).dispatchData.isEmpty) {
      Future.microtask(() async {
        await _refresh();
      });
    }
  }

  Future<void> _refresh() async {
    GlobalLoader.show(context);
    await ref.read(transactionDataProvider.notifier).fetchDispatchData();
    GlobalLoader.hide();
  }

  @override
  Widget build(BuildContext context) {
    final dispatchList =
        ref
            .watch(transactionDataProvider)
            .dispatchData
            .where((d) => d.isActive)
            .toList();
    final appLocal = AppLocalizations.of(context)!;
    final trucks = ref.read(appDataProvider).trucks;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refresh,
          child:
              dispatchList.isEmpty
                  ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 500,
                        child: Center(
                          child: Text(
                            appLocal.dispatchNotFound,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: dispatchList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final dispatch = dispatchList[index];
                      final income = dispatch.totalRevenue ?? 0;
                      final expense = dispatch.totalCost ?? 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade400,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ID + Date
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${appLocal.id}: ${dispatch.id}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${appLocal.date}: ${dispatch.dispatchingDate != null ? "${dispatch.dispatchingDate!.day}/${dispatch.dispatchingDate!.month}/${dispatch.dispatchingDate!.year}" : appLocal.noDate}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Truck name
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${appLocal.truck}: ${trucks.firstWhere((truck) => truck.id == dispatch.truck['id'], orElse: () => Truck(id: 0, name: 'Error', imei: '')).name}",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  color: Colors.tealAccent.shade200,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const Divider(color: Colors.white24, height: 24),

                            // Income & Expense
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildMoneyColumn(
                                  context,
                                  appLocal.income,
                                  "+${income.toStringAsFixed(0)} Ks",
                                  Colors.greenAccent.shade200,
                                ),
                                _buildMoneyColumn(
                                  context,
                                  appLocal.expense,
                                  "-${expense.toStringAsFixed(0)} Ks",
                                  Colors.orangeAccent,
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Driver name
                            Text(
                              "${appLocal.driverName}: ${dispatch.driver ?? appLocal.unknown}",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: Colors.white70),
                            ),

                            const SizedBox(height: 8),

                            // Detail button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  context.pushNamed(
                                    'dispatch-detail',
                                    pathParameters: {
                                      'id': dispatch.id.toString(),
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_outward,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                label: Text(
                                  appLocal.viewDetail,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade700,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
        Positioned(
          bottom: 22,
          right: 16,
          child: FloatingActionButton.extended(
            label: Text(
              appLocal.addDispatching,
              style: const TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showCreateDispatchDialog(
                context: context,
                trucks: trucks,
                onConfirm: (date, truck) async {
                  GlobalLoader.show(context);
                  final data = {
                    'dispatch_date': date.toIso8601String(),
                    'truck': truck.id,
                    'driver_name': null,
                  };

                  final res = await ref
                      .read(transactionFormProvider.notifier)
                      .createDispatchData(data);
                  if (res) {
                    showMessage(
                      ref: ref,
                      text: appLocal.success,
                      icon: Icons.check,
                      backgroundColor: Colors.green,
                    );
                    GlobalLoader.hide();
                    return;
                  }
                  showMessage(
                    ref: ref,
                    text: appLocal.error,
                    icon: Icons.error,
                    backgroundColor: Colors.red,
                  );
                  GlobalLoader.hide();
                },
              );
            },

            backgroundColor: Colors.indigoAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyColumn(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> showCreateDispatchDialog({
    required BuildContext context,
    required List<Truck> trucks,
    required void Function(DateTime date, Truck selectedTruck) onConfirm,
  }) async {
    DateTime? selectedDate = DateTime.now();
    Truck? selectedTruck;
    final appLocal = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(appLocal.addTruckDispatching),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Picker
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.indigoAccent.withAlpha(220),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedDate != null
                            ? '${appLocal.date}: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                            : appLocal.pickedDate,
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Truck Dropdown
                  DropdownButtonFormField<Truck>(
                    decoration: InputDecoration(
                      labelText: appLocal.selectDate,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    isExpanded: true,
                    value: selectedTruck,
                    items:
                        trucks.map((truck) {
                          return DropdownMenuItem(
                            value: truck,
                            child: Text(truck.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTruck = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      selectedDate != null && selectedTruck != null
                          ? () {
                            Navigator.of(context).pop();
                            onConfirm(selectedDate!, selectedTruck!);
                          }
                          : null,
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
