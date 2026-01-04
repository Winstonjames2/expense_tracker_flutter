import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

class DeleteTransactionButton extends ConsumerWidget {
  final int transactionId;

  const DeleteTransactionButton({super.key, required this.transactionId});

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final appLocal = AppLocalizations.of(context)!;
    final notifier = ref.read(transactionFormProvider.notifier);
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  appLocal.confirm,
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(
                  appLocal.deleteTransactionConfirmation,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                elevation: 6,
                shadowColor: Colors.red.withAlpha(80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withAlpha(100), width: 2),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      appLocal.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent.withAlpha(220),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      appLocal.delete,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
    try {
      if (confirmed) {
        notifier.setSendingData(true);
        final res = await ref
            .read(transactionFormProvider.notifier)
            .deleteTransactionData(transactionId);
        if (!res) {
          showMessage(
            ref: ref,
            text: appLocal.failedToDelete,
            backgroundColor: Colors.red,
            icon: Icons.error,
          );
          return;
        }
        if (context.mounted) {
          Navigator.pop(context);
          showMessage(
            ref: ref,
            text: appLocal.successfullyDeletedTransaction,
            backgroundColor: Colors.green,
            icon: Icons.check,
          );
        }
      }
    } catch (e) {
      showMessage(
        ref: ref,
        text: appLocal.failedToDelete,
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      notifier.setSendingData(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    final String btnLabel = appLocal.deleteTransaction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => _confirmAndDelete(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(btnLabel, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
