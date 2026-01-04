import 'package:finager/components/loading_overlay.dart';
import 'package:finager/models/transaction.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/screens/dispatch/dispatchDetail/components/add_new_dispatch_transaction.dart';
import 'package:finager/screens/dispatch/dispatchDetail/components/child_transaction_list.dart';
import 'package:finager/screens/dispatch/dispatchDetail/components/detail_summary.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:finager/screens/transaction_history/transaction_query_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:finager/l10n/app_localizations.dart';

class DispatchDetailScreen extends ConsumerStatefulWidget {
  final int dispatchId;

  const DispatchDetailScreen({super.key, required this.dispatchId});

  @override
  DispatchDetailScreenState createState() => DispatchDetailScreenState();
}

final dispatchTransactionProvider =
    StateNotifierProvider<DispatchTransactionNotifier, List<Transaction>>(
      (ref) => DispatchTransactionNotifier(),
    );

class DispatchTransactionNotifier extends StateNotifier<List<Transaction>> {
  DispatchTransactionNotifier() : super([]);

  void setTransactions(List<Transaction> transactions) {
    state = transactions;
  }

  void clear() {
    state = [];
  }
}

class DispatchDetailScreenState extends ConsumerState<DispatchDetailScreen> {
  final transactionQueryService = TransactionQueryService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final formNotifier = ref.read(transactionFormProvider.notifier);
      formNotifier.resetForm();
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    ref.read(transactionFormProvider.notifier).setSendingData(true);
    await transactionQueryService.fetchDispatchTransactionData(
      ref: ref,
      dispatchId: widget.dispatchId,
    );
    ref.read(transactionFormProvider.notifier).setSendingData(false);
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final transactions = ref.watch(dispatchTransactionProvider);
    final isFormLoading = ref.watch(transactionFormProvider).isSendingData;
    final provider = ref.watch(transactionDataProvider);
    final dispatching = provider.dispatchData.firstWhereOrNull(
      (d) => d.id == widget.dispatchId,
    );

    final isProviderLoading = provider.isLoading;
    final isLoading = isFormLoading || isProviderLoading;
    final isActiveDispatch = dispatching?.isActive ?? false;

    if (dispatching == null && !isProviderLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            appLocal.dispatchDetail,
            style: const TextStyle(color: Colors.white),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: SizedBox.expand(
          child: Center(
            child: Text(
              appLocal.dispatchNotFound,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${appLocal.dispatch} ID: ${widget.dispatchId}',
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigoAccent.withAlpha(220),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Stack(
          children: [
            if (dispatching != null)
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailSummary(
                      dispatching: dispatching,
                      isActiveDispatch: isActiveDispatch,
                    ),
                    const SizedBox(height: 16),
                    AddNewDispatchTransaction(
                      dispatchId: dispatching.id,
                      activeDispatch: isActiveDispatch,
                    ),
                    const SizedBox(height: 16),
                    ChildTransactionList(transaction: transactions),
                  ],
                ),
              ),
            LoadingOverlay(visible: isLoading),
          ],
        ),
      ),
    );
  }
}
