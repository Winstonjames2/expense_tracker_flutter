import 'package:finager/components/add_transaction_button.dart';
import 'package:finager/components/transaction_type_field.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/screens/dispatch/components/dispatch_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/components/amount_field.dart';
import 'package:finager/components/category_dropdown.dart';
import 'package:finager/components/date_time_field.dart';
import 'package:finager/components/description_field.dart';
import 'package:finager/components/payment_method_dropdown.dart';
import 'package:finager/l10n/app_localizations.dart';

class AddNewDispatchTransaction extends ConsumerStatefulWidget {
  final int? dispatchId;
  final bool activeDispatch;

  const AddNewDispatchTransaction({
    super.key,
    this.dispatchId,
    this.activeDispatch = false,
  });

  @override
  ConsumerState<AddNewDispatchTransaction> createState() =>
      _AddNewDispatchTransactionState();
}

final formExpandedProvider = StateProvider<bool>((ref) => true);

class _AddNewDispatchTransactionState
    extends ConsumerState<AddNewDispatchTransaction>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    bool isExpanded = ref.watch(formExpandedProvider);
    if (!widget.activeDispatch) {
      isExpanded = false;
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigoAccent.withAlpha(220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              icon: Icon(isExpanded ? Icons.compress : Icons.add, size: 20),
              label: Text(
                isExpanded ? appLocal.collapse : appLocal.addTransaction,
              ),

              onPressed: () {
                ref.read(detailEditingProvider.notifier).state = false;
                ref.read(transactionFormProvider.notifier).resetForm();
                setState(() {
                  ref.read(formExpandedProvider.notifier).state = !isExpanded;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 22),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child:
              isExpanded
                  ? Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(52, 152, 152, 152),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          DateTimeField(),
                          const SizedBox(height: 32),
                          CategoryDropdown(isHouseholdForm: false),
                          const SizedBox(height: 32),
                          TransactionTypeField(),
                          const SizedBox(height: 32),
                          DescriptionField(),
                          const SizedBox(height: 32),
                          PaymentMethodDropdown(),
                          const SizedBox(height: 32),
                          AmountField(),
                          const SizedBox(height: 32),
                          AddTransactionButton(
                            btnLabel: appLocal.addDispatching,
                            dispatchId: widget.dispatchId,
                            formKey: _formKey,
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
