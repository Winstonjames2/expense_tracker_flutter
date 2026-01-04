import 'package:finager/components/loading_overlay.dart';
import 'package:finager/screens/transaction_history/transaction_history_screen.dart';
import 'package:finager/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/components/custom_bottom_app_bar.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/screens/home/home_screen.dart';
import 'package:finager/screens/analytics_screen.dart';
import 'package:finager/utils/page_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);
    final pageController = ref.watch(pageControllerProvider);
    final currentPage = ref.watch(currentPageProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Material(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                ref.read(currentPageProvider.notifier).state = index;
              },
              children: const [
                HomeScreen(),
                TransactionHistoryScreen(),
                AnalyticsScreen(),
                SettingsScreen(),
              ],
            ),
            Positioned(
              bottom: 2.0,
              left: 3.0,
              right: 3.0,
              child: CustomBottomAppBar(
                pageController: pageController,
                currentPage: currentPage,
              ),
            ),
            LoadingOverlay(visible: appData.isLoading),
          ],
        ),
      ),
    );
  }
}
