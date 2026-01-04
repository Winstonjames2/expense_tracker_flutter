import 'package:finager/components/global_loader.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:finager/screens/dispatch/components/dispatch_card.dart';
import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DispatchList extends ConsumerStatefulWidget {
  const DispatchList({super.key});

  @override
  ConsumerState<DispatchList> createState() => _DispatchListState();
}

class _DispatchListState extends ConsumerState<DispatchList> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentScroll = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (currentScroll >= maxScroll - 0) {
      _loadMoreDispatchData();
    }

    final showButton = currentScroll > 300;
    if (_showScrollToTopButton != showButton) {
      setState(() => _showScrollToTopButton = showButton);
    }
  }

  Future<void> _loadMoreDispatchData() async {
    final currentPage = ref.read(transactionDataProvider).dispatchNextPage;
    GlobalLoader.show(context);
    if (currentPage == 1) {
      showMessage(
        ref: ref,
        text: "No more dispatches to load.",
        backgroundColor: Colors.red,
        icon: Icons.info,
      );
      GlobalLoader.hide();
      return;
    }

    await ref
        .read(transactionDataProvider.notifier)
        .fetchDispatchData(isReload: false);
    GlobalLoader.hide();
  }

  Future<void> _refreshDispatchData() async {
    GlobalLoader.show(context);
    await ref.read(transactionDataProvider.notifier).fetchDispatchData();
    GlobalLoader.hide();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dispatchCards = ref.watch(transactionDataProvider).dispatchData;
    return Scaffold(
      floatingActionButton:
          _showScrollToTopButton
              ? FloatingActionButton(
                backgroundColor: Colors.indigoAccent.withAlpha(220),
                onPressed:
                    () => _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    ),
                child: const Icon(Icons.arrow_upward),
              )
              : null,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshDispatchData,
            edgeOffset: 10,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final dispatch = dispatchCards[index];
                    return DispatchCard(dispatch: dispatch);
                  }, childCount: dispatchCards.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
