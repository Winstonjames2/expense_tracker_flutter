import 'package:finager/models/transaction.dart';
import 'package:finager/screens/edit_transaction/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

class ChildTransactionList extends ConsumerWidget {
  final List<Transaction> transaction;

  const ChildTransactionList({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transaction.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          AppLocalizations.of(context)!.transactionNotFound,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transaction.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final tx = transaction[index];
        return TransactionCard(tx: tx);
      },
    );
  }
}
