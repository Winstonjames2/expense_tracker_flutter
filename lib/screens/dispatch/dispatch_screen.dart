import 'package:finager/screens/dispatch/dispatch_list.dart';
import 'package:finager/screens/dispatch/active_truck_dispatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:finager/providers/transaction_form_provider.dart';

class DispatchScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const DispatchScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<DispatchScreen> createState() => _DispatchScreenState();
}

final addTransactionPageProvider = StateProvider<int>((ref) => 0);

class _DispatchScreenState extends ConsumerState<DispatchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.index = widget.initialTab;
      _pageController.jumpToPage(widget.initialTab);
      ref.read(addTransactionPageProvider.notifier).state = widget.initialTab;
      ref.read(transactionFormProvider.notifier).resetForm();
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(addTransactionPageProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.indigoAccent.withAlpha(220),
          foregroundColor: Colors.white,
          elevation: 6,
          centerTitle: true,
          shadowColor: Colors.black.withAlpha(100),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              currentPage == 0
                  ? AppLocalizations.of(context)!.activeDispatch
                  : AppLocalizations.of(context)!.dispatchList,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 5.0,
                color: Color.fromARGB(255, 22, 29, 105),
              ),
              insets: EdgeInsets.symmetric(horizontal: 50.0),
            ),
            indicatorWeight: 4.0,
            indicatorColor: Colors.indigo.shade900,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.local_shipping,
                  color:
                      currentPage == 0
                          ? const Color.fromARGB(255, 16, 21, 78)
                          : Colors.indigo,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list_alt,
                  color:
                      currentPage == 1
                          ? const Color.fromARGB(255, 16, 21, 78)
                          : Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (idx) {
          setState(
            () => ref.read(addTransactionPageProvider.notifier).state = idx,
          );
          _tabController.index = idx;
        },
        children: const [ActiveTruckDispatch(), DispatchList()],
      ),
    );
  }
}
