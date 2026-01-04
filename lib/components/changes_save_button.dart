import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/models/transaction.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class ChangesSaveButton extends ConsumerWidget {
  final bool isDispatchTransaction;
  final GlobalKey<FormState> formKey;
  final Transaction oldTransaction;

  const ChangesSaveButton({
    super.key,
    required this.isDispatchTransaction,
    required this.formKey,
    required this.oldTransaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionFormProvider.notifier);
    final state = ref.watch(transactionFormProvider);
    final appLocal = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        notifier.setSendingData(true);
        final result = await notifier.saveFormChanges(
          original: oldTransaction,
          isDispatchTransaction: isDispatchTransaction,
        );
        switch (result) {
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
            showMessage(
              ref: ref,
              text: appLocal.successfullyUpdatedChanges,
              icon: Icons.check,
              backgroundColor: Colors.green,
            );
            break;
        }
        notifier.setSendingData(false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent.withAlpha(220),
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
              : Text(
                appLocal.saveChanges,
                style: const TextStyle(color: Colors.white),
              ),
    );
  }
}
