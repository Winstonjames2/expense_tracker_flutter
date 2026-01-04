import 'package:finager/components/add_transaction_button.dart';
import 'package:finager/components/date_field.dart';
import 'package:finager/components/transaction_type_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/components/amount_field.dart';
import 'package:finager/components/category_dropdown.dart';
import 'package:finager/components/description_field.dart';
import 'package:finager/l10n/app_localizations.dart';

class AddTransactionForm extends ConsumerStatefulWidget {
  final int? householdId;
  final int? dispatchId;
  final bool isHouseholdForm;

  const AddTransactionForm({
    super.key,
    this.householdId,
    this.dispatchId,
    required this.isHouseholdForm,
  });

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            DateField(),
            const SizedBox(height: 32),
            TransactionTypeField(),
            const SizedBox(height: 32),
            CategoryDropdown(isHouseholdForm: widget.isHouseholdForm),
            const SizedBox(height: 32),
            DescriptionField(),
            const SizedBox(height: 32),
            AmountField(),
            const SizedBox(height: 32),
            AddTransactionButton(
              btnLabel: appLocal.addTransaction,
              formKey: _formKey,
            ),
          ],
        ),
      ),
    );
  }
}
