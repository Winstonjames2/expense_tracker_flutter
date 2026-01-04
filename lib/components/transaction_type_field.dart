import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class TransactionTypeField extends ConsumerWidget {
  final String? initialPaymentType;
  const TransactionTypeField({super.key, this.initialPaymentType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(transactionFormProvider.notifier);
    final formState = ref.watch(transactionFormProvider);
    String? transactionType = initialPaymentType ?? formState.transactionType;
    final appLocal = AppLocalizations.of(context)!;
    final Color borderColor = Colors.indigoAccent.withAlpha(220);

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(appLocal.transactionType, borderColor),
      value: transactionType,
      items: [
        DropdownMenuItem<String>(
          value: 'Expense',
          child: Text(appLocal.expense),
        ),
        DropdownMenuItem<String>(value: 'Income', child: Text(appLocal.income)),
      ],
      onChanged: controller.settransactionType,
      validator:
          (value) =>
              value == null ? appLocal.pleaseSelectTransactionType : null,
    );
  }

  InputDecoration _inputDecoration(String label, borderColor) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.0),
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
