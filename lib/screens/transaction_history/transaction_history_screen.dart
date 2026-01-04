import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/screens/transaction_history/components/transaction_filter_dialog.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:finager/screens/edit_transaction/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showScrollToTopButton = false;
  int _filterIndex = 0;
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    if (ref.read(transactionDataProvider).transactions.isEmpty) {
      Future.microtask(() async {
        await ref.read(transactionDataProvider.notifier).fetchTransaction();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }

    if (_scrollController.position.pixels > 300 && !_showScrollToTopButton) {
      setState(() => _showScrollToTopButton = true);
    } else if (_scrollController.position.pixels <= 300 &&
        _showScrollToTopButton) {
      setState(() => _showScrollToTopButton = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadMore() async {
    if (_isLoading || ref.watch(transactionDataProvider).isLoading) {
      showMessage(
        ref: ref,
        text: AppLocalizations.of(context)!.loadingMsg,
        backgroundColor: Colors.blue,
        icon: Icons.hourglass_top,
      );
      return;
    }
    final isFiltered = ref.watch(transactionDataProvider).isFiltered;
    if (ref.read(transactionDataProvider).transactionNextPage == 1 &&
            !isFiltered ||
        ref.read(transactionDataProvider).filteredTransactionNextPage == 1 &&
            isFiltered) {
      showMessage(
        ref: ref,
        text: AppLocalizations.of(context)!.noMoreTransactions,
        backgroundColor: Colors.red,
        icon: Icons.info,
      );
      return;
    }
    if (mounted) setState(() => _isLoading = true);
    await ref
        .read(transactionDataProvider.notifier)
        .fetchTransaction(isReload: false);
    if (mounted) setState(() => _isLoading = false);
  }

  void _openFilterDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransactionFilterDialog(),
    );

    if (result != null) {
      _fromDate = result['from'];
      _toDate = result['to'];
      _categoryId = result['category'];
      ref.read(transactionDataProvider.notifier).setIsFiltered(true);
      await ref
          .read(transactionDataProvider.notifier)
          .fetchTransaction(
            fromDate: _fromDate,
            toDate: _toDate,
            categoryId: _categoryId,
            isReload: true,
          );
    }
  }

  Widget _buildFilterChips(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final types = [
      {"All": appLocal.all},
      {"Income": appLocal.income},
      {"Expense": appLocal.expense},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...types.map((type) {
            final index = types.indexOf(type);
            final isSelected = _filterIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.indigo : Colors.grey.shade300,
                  width: 0.4,
                ),
                label: Text(type.values.first),
                selected: isSelected,
                onSelected: (_) => setState(() => _filterIndex = index),
                selectedColor: Colors.indigo.shade600,
                backgroundColor: Colors.grey.shade100,
                labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            );
          }),
          Container(
            margin: EdgeInsets.only(left: 12),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white, size: 28),
              onPressed: _openFilterDialog,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final provider = ref.watch(transactionDataProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 63, 81, 181),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(180, 0, 0, 0),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (provider.filteredList['fromDate'] != null &&
                provider.filteredList.containsKey('fromDate'))
              _buildFilterChip(
                "${appLocal.fromDate}: ${provider.filteredList['fromDate']!.toLocal().toString().split(' ')[0]}",
              ),
            if (provider.filteredList['toDate'] != null &&
                provider.filteredList.containsKey('toDate'))
              _buildFilterChip(
                "${appLocal.toDate}: ${provider.filteredList['toDate']!.toLocal().toString().split(' ')[0]}",
              ),
            if (provider.filteredList['categoryId'] != null &&
                provider.filteredList.containsKey('categoryId'))
              _buildFilterChip(
                "${appLocal.category}: ${ref.read(appDataProvider).categories.firstWhere((cat) => cat.id == provider.filteredList['categoryId']).name}",
              ),
            IconButton(
              icon: const Icon(Icons.cancel),
              iconSize: 30,
              color: Colors.red.shade600,
              tooltip: appLocal.close,
              onPressed: () {
                ref.read(transactionDataProvider.notifier).clearFilter();
                _scrollToTop();
                setState(() {
                  _fromDate = null;
                  _toDate = null;
                  _categoryId = null;
                  _filterIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(text, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionDataState = ref.watch(transactionDataProvider);
    final isFiltered = transactionDataState.isFiltered;

    final filteredTransactions =
        (isFiltered
                ? transactionDataState.filteredTransactions
                : transactionDataState.transactions)
            .where((tx) {
              if (_filterIndex == 0) return true;
              return tx.transactionType ==
                  (_filterIndex == 1 ? "Income" : "Expense");
            })
            .toList();

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            displacement: 40,
            edgeOffset: isFiltered ? 200 : 120,
            onRefresh: () async {
              await ref
                  .read(transactionDataProvider.notifier)
                  .fetchTransaction(
                    isReload: true,
                    fromDate: _fromDate,
                    toDate: _toDate,
                    categoryId: _categoryId,
                  );
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: false,
                  floating: false,
                  snap: false,
                  backgroundColor: Colors.indigoAccent.withAlpha(200),
                  elevation: 2,
                  foregroundColor: Colors.white,
                  title: Text(AppLocalizations.of(context)!.transactionHistory),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _buildFilterChips(context),
                    ),
                  ),
                ),
                if (isFiltered)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverHeaderDelegate(
                      minHeight: 80,
                      maxHeight: 80,
                      child: _buildActiveFilterChips(context),
                    ),
                  ),

                filteredTransactions.isEmpty
                    ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noTransactionFound,
                        ),
                      ),
                    )
                    : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (_isLoading &&
                              index == filteredTransactions.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final tx = filteredTransactions[index];
                          return TransactionCard(tx: tx);
                        },
                        childCount:
                            filteredTransactions.length + (_isLoading ? 1 : 0),
                      ),
                    ),
                SliverToBoxAdapter(child: SizedBox(height: 160)),
              ],
            ),
          ),
          if (ref.read(transactionDataProvider).isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(120),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.indigoAccent.withAlpha(180),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          _showScrollToTopButton
              ? Padding(
                padding: const EdgeInsets.only(bottom: 60.0), // Move FAB up
                child: FloatingActionButton(
                  backgroundColor: Colors.indigoAccent.shade400,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              )
              : null,
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  const _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Colors.transparent,
      child: SizedBox.expand(child: child),
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}
