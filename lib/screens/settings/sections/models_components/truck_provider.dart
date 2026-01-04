import 'package:finager/components/global_loader.dart';
import 'package:finager/models/truck.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/load_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model_form_dialog.dart';
import 'model_list_page.dart';
import 'package:finager/l10n/app_localizations.dart';

class TruckProvider {
  final int id;
  final String name;
  TruckProvider(this.id, this.name);
}

class TruckModelProvider extends ModelProvider<TruckProvider> {
  final WidgetRef ref;
  TruckModelProvider(this.ref);

  @override
  Future<List<TruckProvider>> getAll() async =>
      ref
          .read(appDataProvider)
          .trucks
          .map((e) => TruckProvider(e.id, e.name))
          .toList();

  @override
  Future<bool> delete(List<TruckProvider> selected) async {
    bool allPassed = true;
    final loadDataProvider = LoadDataProvider();

    for (var truck in selected) {
      final success = await loadDataProvider.deleteModel('truck', truck.id);
      if (!success) {
        allPassed = false;
      }
    }

    final appData = ref.read(appDataProvider);
    final updatedTrucks = List<Truck>.from(appData.trucks)
      ..removeWhere((t) => selected.any((sel) => sel.id == t.id));
    ref.read(appDataProvider.notifier).setTruck(updatedTrucks);
    return allPassed;
  }

  @override
  Future<dynamic> fetchFullData(dynamic item) async {
    final id = item.id;
    return ref.read(appDataProvider).trucks.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> showViewDialog(BuildContext context, dynamic item) async {
    final appLocal = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(appLocal.truckDetail),
            content: Text(
              "${appLocal.truckNumber}: ${item.name}\nIMEI: ${item.imei}\n"
              "${appLocal.color}: ${item.color ?? 'N/A'}\n"
              "${appLocal.truckType}: ${item.truckType ?? 'N/A'}\n"
              "${appLocal.licenseExpiryDate}: ${item.licenseExpDate != null ? DateTime.tryParse(item.licenseExpDate)?.toLocal().toString().split(' ')[0] ?? 'N/A' : 'N/A'}",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(appLocal.close),
              ),
            ],
          ),
    );
  }

  @override
  String getDisplay(TruckProvider item) => item.name;

  @override
  Future<TruckProvider?> showAddEditDialog(
    BuildContext context, {
    dynamic initial,
  }) {
    final nameController = TextEditingController(text: initial?.name);
    final imeiController = TextEditingController(text: initial?.imei);
    final colorController = TextEditingController(text: initial?.color);
    final typeController = TextEditingController(text: initial?.truckType);
    DateTime? licenseDate =
        initial?.licenseExpDate != null
            ? DateTime.tryParse(initial.licenseExpDate)
            : null;
    final appLocal = AppLocalizations.of(context)!;

    return showModelFormDialog(
      context: context,
      form: StatefulBuilder(
        builder:
            (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appLocal.addTruck,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '${appLocal.truckNumber} *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imeiController,
                  decoration: const InputDecoration(
                    labelText: 'GPS IMEI *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: colorController,
                  decoration: InputDecoration(
                    labelText: appLocal.color,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: appLocal.truckType,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => licenseDate = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '${appLocal.licenseExpiryDate} *',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      licenseDate != null
                          ? licenseDate.toString().split(' ')[0]
                          : appLocal.selectDate,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pressed Logic ___________//
                ElevatedButton(
                  onPressed: () async {
                    GlobalLoader.show(context);
                    if (nameController.text.isEmpty ||
                        imeiController.text.isEmpty ||
                        licenseDate == null) {
                      showMessage(
                        ref: ref,
                        text: appLocal.errTruckModelRequiredFields,
                        backgroundColor: Colors.red,
                        icon: Icons.cancel,
                      );
                      GlobalLoader.hide();
                      return;
                    }
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      bool res;
                      final loadDataProvider = LoadDataProvider();
                      if (initial != null) {
                        final updatedData = <String, dynamic>{};
                        if (nameController.text.trim() != initial.name) {
                          updatedData['name'] = nameController.text.trim();
                        }
                        if (imeiController.text != initial.imei) {
                          updatedData['imei'] = imeiController.text;
                        }
                        if (colorController.text != initial.color) {
                          updatedData['color'] = colorController.text;
                        }
                        if (typeController.text != initial.truckType) {
                          updatedData['truck_type'] = typeController.text;
                        }
                        final initialLicenseDate =
                            initial.licenseExpDate != null
                                ? DateTime.tryParse(initial.licenseExpDate)
                                : null;
                        if (licenseDate != initialLicenseDate) {
                          updatedData['license_expiry_date'] =
                              licenseDate!.toIso8601String();
                        }
                        if (updatedData.isEmpty) {
                          showMessage(
                            ref: ref,
                            text: appLocal.noChangesMade,
                            backgroundColor: Colors.yellow,
                            icon: Icons.warning_rounded,
                          );
                          GlobalLoader.hide();
                          return;
                        }
                        res = await loadDataProvider.updateModel(
                          'truck',
                          initial.id,
                          updatedData,
                        );
                      } else {
                        res = await loadDataProvider.addModel('truck', {
                          'name': nameController.text.trim(),
                          'imei': imeiController.text,
                          'color': colorController.text,
                          'truck_type': typeController.text,
                          'license_expiry_date': licenseDate!.toIso8601String(),
                        }, ref);
                      }
                      if (!res) {
                        showMessage(
                          ref: ref,
                          text: appLocal.error,
                          backgroundColor: Colors.red,
                          icon: Icons.cancel,
                        );
                        GlobalLoader.hide();
                        return;
                      }
                      await loadDataProvider.fetchTrucks();
                      await ref
                          .read(appDataProvider.notifier)
                          .loadModelPreferencesData();

                      showMessage(
                        ref: ref,
                        text: appLocal.success,
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                      );
                      GlobalLoader.hide();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent.shade700.withAlpha(
                      220,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(appLocal.save),
                ),
              ],
            ),
      ),
    );
  }
}
