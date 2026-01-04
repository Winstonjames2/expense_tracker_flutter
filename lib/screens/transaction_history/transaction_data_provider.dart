import 'package:finager/models/dispatch_data.dart';
import 'package:finager/models/transaction.dart';
import 'package:finager/screens/transaction_history/transaction_query_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionDataProvider =
    StateNotifierProvider<TransactionDataNotifier, TransactionDataState>(
      (ref) => TransactionDataNotifier(ref),
    );

class TransactionDataState {
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final List<DispatchData> dispatchData;
  final int dispatchNextPage;
  final int transactionNextPage;
  final int filteredTransactionNextPage;
  final bool isLoading;
  final bool isFiltered;
  final Map<String, dynamic> filteredList;

  TransactionDataState({
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.dispatchData = const [],
    this.dispatchNextPage = 1,
    this.transactionNextPage = 1,
    this.filteredTransactionNextPage = 1,
    this.isLoading = false,
    this.isFiltered = false,
    this.filteredList = const {},
  });

  TransactionDataState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    List<DispatchData>? dispatchData,
    Map<String, dynamic>? filteredList,
    bool? isLoading,
    bool? isFiltered,
    int? transactionNextPage,
    int? filteredTransactionNextPage,
    int? dispatchNextPage,
  }) {
    return TransactionDataState(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      dispatchData: dispatchData ?? this.dispatchData,
      dispatchNextPage: dispatchNextPage ?? this.dispatchNextPage,
      transactionNextPage: transactionNextPage ?? this.transactionNextPage,
      filteredTransactionNextPage:
          filteredTransactionNextPage ?? this.filteredTransactionNextPage,
      isLoading: isLoading ?? this.isLoading,
      isFiltered: isFiltered ?? this.isFiltered,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

class TransactionDataNotifier extends StateNotifier<TransactionDataState> {
  final Ref ref;

  TransactionDataNotifier(this.ref)
    : super(
        TransactionDataState(
          transactions: const [],
          filteredTransactions: const [],
          dispatchData: const [],
          dispatchNextPage: 1,
          transactionNextPage: 1,
          filteredTransactionNextPage: 1,
          isLoading: false,
          isFiltered: false,
          filteredList: const {},
        ),
      );

  final transactionQueryService = TransactionQueryService();

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setIsFiltered(bool isFiltered) {
    state = state.copyWith(isFiltered: isFiltered);
  }

  Future<void> fetchDispatchData({bool isReload = true}) async {
    setLoading(true);
    if (isReload) {
      state = state.copyWith(dispatchNextPage: 1, dispatchData: []);
    }
    final data = await transactionQueryService.fetchDispatching(
      page: state.dispatchNextPage,
    );
    final updatedDispatchData = [...state.dispatchData, ...data['data']];
    final uniqueDispatchData =
        {for (var d in updatedDispatchData) d.id: d}.values.toList()
          ..sort((a, b) => b.id.compareTo(a.id));
    state = state.copyWith(
      dispatchNextPage: data['hasMore'] ? state.dispatchNextPage + 1 : 1,
      dispatchData: uniqueDispatchData.cast<DispatchData>(),
    );
    setLoading(false);
  }

  Future<void> fetchTransaction({
    DateTime? fromDate,
    DateTime? toDate,
    int? categoryId,
    bool isReload = true,
  }) async {
    setLoading(true);
    final isFiltered = state.isFiltered;
    if (isReload) {
      state =
          isFiltered
              ? state.copyWith(
                filteredTransactionNextPage: 1,
                filteredTransactions: [],
              )
              : state.copyWith(transactionNextPage: 1, transactions: []);
    }

    final data = await transactionQueryService.fetchTransaction(
      fromDate: fromDate,
      toDate: toDate,
      categoryId: categoryId,
      page:
          isFiltered
              ? state.filteredTransactionNextPage
              : state.transactionNextPage,
    );

    final updatedTransactions =
        isFiltered
            ? [...state.filteredTransactions, ...data['data']]
            : [...state.transactions, ...data['data']];

    final uniqueTransactions =
        {for (var d in updatedTransactions) d.id: d}.values.toList()
          ..sort((a, b) => b.id.compareTo(a.id));

    state =
        isFiltered
            ? state.copyWith(
              isFiltered: true,
              filteredTransactionNextPage:
                  data['hasMore'] ? state.filteredTransactionNextPage + 1 : 1,
              filteredTransactions: uniqueTransactions.cast<Transaction>(),
              isLoading: false,
              filteredList:
                  isReload
                      ? {
                        'fromDate': fromDate,
                        'toDate': toDate,
                        'categoryId': categoryId,
                      }
                      : state.filteredList,
            )
            : state.copyWith(
              isFiltered: false,
              transactionNextPage:
                  data['hasMore'] ? state.transactionNextPage + 1 : 1,
              transactions: uniqueTransactions.cast<Transaction>(),
            );
    setLoading(false);
  }

  Future<void> clearFilter() async {
    state = state.copyWith(
      filteredTransactionNextPage: 1,
      filteredTransactions: [],
      filteredList: {},
      isFiltered: false,
    );
  }

  void addTransaction(Transaction transaction) {
    final updatedTransactions = [transaction, ...state.transactions];
    setIsFiltered(false);
    state = state.copyWith(transactions: updatedTransactions);
  }

  void updateTransaction(Transaction transaction) {
    final updatedTransactions =
        state.transactions.map((t) {
          return t.id == transaction.id ? transaction : t;
        }).toList();
    final updatedFilteredTransactions =
        state.filteredTransactions.map((t) {
          return t.id == transaction.id ? transaction : t;
        }).toList();

    state = state.copyWith(
      transactions: updatedTransactions,
      filteredTransactions: updatedFilteredTransactions,
    );
  }

  void removeTransaction(int transactionId) {
    final updatedTransactions =
        state.transactions
            .where((transaction) => transaction.id != transactionId)
            .toList();
    final updatedFilteredTransactions =
        state.filteredTransactions
            .where((transaction) => transaction.id != transactionId)
            .toList();
    state = state.copyWith(
      transactions: updatedTransactions,
      filteredTransactions: updatedFilteredTransactions,
    );
  }

  void updateDispatching(DispatchData dispatching) {
    final updatedDispatchData =
        state.dispatchData.map((d) {
          return d.id == dispatching.id ? dispatching : d;
        }).toList();
    state = state.copyWith(dispatchData: updatedDispatchData);
  }

  void removeDispatching(int dispatchingId) {
    final updatedDispatchData =
        state.dispatchData.where((d) => d.id != dispatchingId).toList();
    state = state.copyWith(dispatchData: updatedDispatchData);
  }

  Future<void> refreshData({isReload = true, isLoading = true}) async {
    state = state.copyWith(isLoading: isLoading);
    await fetchTransaction();
    state = state.copyWith(isLoading: false);
  }

  Future<void> refreshHomePage() async {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(isLoading: false);
  }

  void updateDispatchData(int id, bool value) {
    final updatedDispatchData =
        state.dispatchData.map((d) {
          return d.id == id ? d.copyWith(isActive: value) : d;
        }).toList();
    state = state.copyWith(dispatchData: updatedDispatchData);
  }
}
