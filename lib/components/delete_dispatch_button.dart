import 'package:finager/components/global_loader.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

class DeleteButton extends ConsumerWidget {
  final int dispatchId;
  final VoidCallback? onDeleted;

  const DeleteButton({super.key, required this.dispatchId, this.onDeleted});

  Future<bool> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final appLocal = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(appLocal.confirm),
                content: Text(appLocal.areYouSureToDelete),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      appLocal.cancel,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      appLocal.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    final String btnLabel = appLocal.delete;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              final bool confirmed = await _confirmAndDelete(context, ref);
              if (confirmed) {
                if (context.mounted) GlobalLoader.show(context);
                final res = await ref
                    .read(transactionFormProvider.notifier)
                    .deleteDispatchData(dispatchId);
                if (res) {
                  if (context.mounted) Navigator.of(context).pop();
                  onDeleted?.call();
                  ref
                      .read(transactionDataProvider.notifier)
                      .removeDispatching(dispatchId);
                  if (context.mounted) {
                    showMessage(
                      ref: ref,
                      text:
                          AppLocalizations.of(
                            context,
                          )!.successfullyDeletedTransaction,
                      backgroundColor: Colors.green,
                      icon: Icons.check,
                    );
                  }
                } else {
                  if (context.mounted) {
                    showMessage(
                      ref: ref,
                      text: AppLocalizations.of(context)!.failedToDelete,
                      backgroundColor: Colors.red,
                      icon: Icons.info,
                    );
                  }
                }
              }
            } catch (e) {
              if (context.mounted) {
                showMessage(
                  ref: ref,
                  text: AppLocalizations.of(context)!.failedToDelete,
                  backgroundColor: Colors.red,
                  icon: Icons.info,
                );
              }
            } finally {
              GlobalLoader.hide();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete, color: Colors.white, size: 18),
                const SizedBox(width: 5),
                Text(btnLabel, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow.shade800),
            borderRadius: BorderRadius.circular(6),
            color: Colors.yellow,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            '! ${appLocal.dispatchinDeleteNotice}',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
