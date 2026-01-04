import 'package:finager/components/changes_save_button.dart';
import 'package:finager/components/date_field.dart';
import 'package:finager/components/delete_transaction_button.dart';
import 'package:finager/components/transaction_type_field.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:finager/l10n/app_localizations.dart';
import '../../../../models/transaction.dart';
import '../../../../components/date_time_field.dart';
import '../../../../components/amount_field.dart';
import '../../../../components/description_field.dart';
import '../../../../components/payment_method_dropdown.dart';
import '../../../../components/category_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionEditPage extends ConsumerStatefulWidget {
  final Transaction transaction;
  const TransactionEditPage({super.key, required this.transaction});
  @override
  ConsumerState<TransactionEditPage> createState() =>
      _TransactionEditPageState();
}

class _TransactionEditPageState extends ConsumerState<TransactionEditPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionFormProvider.notifier).resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final hasTruck = widget.transaction.truckDispatching != null;
    final isLoading = ref.watch(transactionFormProvider).isSendingData;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editTransaction),
        elevation: 1,
        backgroundColor: Colors.indigoAccent.withAlpha(220),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hasTruck
                      ? DateTimeField(initialDate: widget.transaction.date)
                      : DateField(initialDate: widget.transaction.date),
                  const SizedBox(height: 16),
                  TransactionTypeField(
                    initialPaymentType: widget.transaction.transactionType,
                  ),
                  const SizedBox(height: 16),
                  CategoryDropdown(
                    isHouseholdForm: !hasTruck,
                    initialCategory: widget.transaction.category,
                  ),
                  const SizedBox(height: 16),
                  DescriptionField(
                    initialDescription: widget.transaction.description,
                  ),
                  const SizedBox(height: 16),
                  if (hasTruck)
                    PaymentMethodDropdown(
                      initialPaymentMethod: widget.transaction.paymentMethod,
                    ),
                  const SizedBox(height: 16),
                  AmountField(initialAmount: widget.transaction.amount),
                  const SizedBox(height: 16),
                  ChangesSaveButton(
                    isDispatchTransaction: hasTruck,
                    oldTransaction: widget.transaction,
                    formKey: _formKey,
                  ),
                  const SizedBox(height: 32),
                  DeleteTransactionButton(transactionId: widget.transaction.id),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(100),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
