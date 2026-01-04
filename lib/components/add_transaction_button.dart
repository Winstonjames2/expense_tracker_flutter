import 'package:finager/providers/message_provider.dart';
import 'package:finager/screens/transaction_history/transaction_query_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class AddTransactionButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final String btnLabel;
  final int? dispatchId;

  const AddTransactionButton({
    super.key,
    required this.btnLabel,
    required this.formKey,
    this.dispatchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionFormProvider.notifier);
    final state = ref.watch(transactionFormProvider);

    final appLocal = AppLocalizations.of(context)!;
    final borderColor = Colors.indigoAccent.withAlpha(220);

    return ElevatedButton(
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        bool success = false;
        try {
          notifier.setSendingData(true);
          success = await notifier.submitNewData(dispatchId: dispatchId);
          if (success && dispatchId != null) {
            TransactionQueryService().fetchDispatchTransactionData(
              ref: ref,
              dispatchId: dispatchId,
            );
          }
          showMessage(
            ref: ref,
            text:
                success
                    ? appLocal.transactionAddedSuccessfully
                    : appLocal.failedToAddTransaction,
            backgroundColor: success ? Colors.green : Colors.red,
            icon: success ? Icons.check_circle : Icons.error,
          );
          if (success) notifier.resetForm();
        } catch (e) {
          showMessage(
            ref: ref,
            text: appLocal.failedToAddTransaction,
            backgroundColor: Colors.red,
            icon: Icons.error,
          );
        } finally {
          notifier.setSendingData(false);
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: borderColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 60),
      ),
      child:
          state.isSendingData
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Text(btnLabel, style: const TextStyle(color: Colors.white)),
    );
  }
}
