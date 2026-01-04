import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/truck.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class TruckDropdown extends ConsumerWidget {
  final Map<String, dynamic>? initialTruck;
  const TruckDropdown({super.key, this.initialTruck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(transactionFormProvider.notifier);
    final formState = ref.watch(transactionFormProvider);
    final appState = ref.watch(appDataProvider);

    final borderColor = Colors.indigoAccent.withAlpha(220);
    Truck? selectedTruck;

    if (initialTruck != null && initialTruck?['id'] != null) {
      selectedTruck = appState.trucks.firstWhere(
        (t) => t.id == initialTruck?['id'],
        orElse: () => Truck(id: 0, name: 'Unknown Truck', imei: ''),
      );
    } else if (formState.selectedTruck != null) {
      selectedTruck = appState.trucks.firstWhere(
        (t) => t.id == formState.selectedTruck,
        orElse: () => Truck(id: 0, name: 'Unknown Truck', imei: ''),
      );
    }

    return DropdownButtonFormField<Truck>(
      decoration: _inputDecoration(
        AppLocalizations.of(context)!.truckNumber,
        borderColor,
      ),
      value: selectedTruck,
      onChanged: (Truck? newValue) {
        if (newValue != null) {
          provider.setTruck(newValue.id);
        }
      },
      items:
          appState.trucks.map<DropdownMenuItem<Truck>>((Truck truck) {
            return DropdownMenuItem<Truck>(
              value: truck,
              child: Text(truck.name),
            );
          }).toList(),
      validator:
          (value) => value == null ? 'Please select a truck number' : null,
    );
  }

  InputDecoration _inputDecoration(String label, borderColor) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    );
  }
}
