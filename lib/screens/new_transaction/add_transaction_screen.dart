import 'package:finager/screens/new_transaction/add_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:finager/providers/transaction_form_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const AddTransactionScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionFormProvider.notifier).resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(transactionFormProvider).isSendingData;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addTransaction),
        backgroundColor: Colors.indigoAccent.withAlpha(220),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [AddTransactionForm(isHouseholdForm: true)],
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
