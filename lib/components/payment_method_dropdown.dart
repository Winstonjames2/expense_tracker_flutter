import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class PaymentMethodDropdown extends ConsumerWidget {
  final int? initialPaymentMethod;

  const PaymentMethodDropdown({super.key, this.initialPaymentMethod});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appDataProvider);
    final formState = ref.watch(transactionFormProvider);
    final provider = ref.read(transactionFormProvider.notifier);
    final borderColor = Colors.indigoAccent.withAlpha(220);
    PaymentMethod? selectedPaymentMethod;

    if (initialPaymentMethod != null && initialPaymentMethod != null) {
      selectedPaymentMethod = appState.paymentMethods.firstWhere(
        (method) => method.id == initialPaymentMethod,
        orElse:
            () =>
                appState.paymentMethods.isNotEmpty
                    ? appState.paymentMethods.first
                    : PaymentMethod(id: 1, name: 'Cash'),
      );
    } else if (formState.selectedPaymentMethod != null) {
      selectedPaymentMethod = appState.paymentMethods.firstWhere(
        (method) => method.id == formState.selectedPaymentMethod,
        orElse:
            () =>
                appState.paymentMethods.isNotEmpty
                    ? appState.paymentMethods.first
                    : PaymentMethod(id: 1, name: 'Cash'),
      );
    }

    return DropdownButtonFormField<PaymentMethod>(
      decoration: _inputDecoration(
        AppLocalizations.of(context)!.paymentMethod,
        borderColor,
      ),
      value: selectedPaymentMethod,
      onChanged: (PaymentMethod? newValue) {
        if (newValue != null) {
          provider.setPaymentMethod(newValue.id);
        }
      },
      items:
          appState.paymentMethods.map((method) {
            return DropdownMenuItem<PaymentMethod>(
              value: method,
              child: Text(method.name),
            );
          }).toList(),
      validator:
          (value) =>
              value == null
                  ? AppLocalizations.of(context)!.pleaseSelectPaymentMethod
                  : null,
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
