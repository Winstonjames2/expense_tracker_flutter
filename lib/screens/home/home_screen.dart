import 'package:finager/screens/home/popup_btn_screen.dart';
import 'package:finager/screens/home/stats_screen.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import './home_app_bar.dart';
import './home_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    await ref.read(appDataProvider.notifier).refreshHomePage();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appDataProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      backgroundColor: Colors.indigoAccent.withAlpha(80),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              HomeHeader(
                accounts: appState.accounts,
                tdyIncome: appState.statsData.todayIncome,
                tdyExpense: appState.statsData.todayExpense,
              ),
              const SizedBox(height: 20),
              PopupButtonsSection(),
              const SizedBox(height: 20),
              StatsScreen(statsData: appState.statsData),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
