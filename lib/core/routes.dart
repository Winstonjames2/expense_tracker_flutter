import 'package:finager/models/transaction.dart';
import 'package:finager/screens/edit_transaction/edit_transaction_screen.dart';
import 'package:finager/screens/dispatch/dispatchDetail/dispatch_detail_screen.dart';
import 'package:finager/screens/dispatch/dispatch_screen.dart';
import 'package:finager/screens/login_screen.dart';
import 'package:finager/screens/home/home_screen.dart';
import 'package:finager/screens/main_screen.dart';
import 'package:finager/screens/new_transaction/add_transaction_screen.dart';
import 'package:finager/screens/settings/sections/model_settings.dart';
import 'package:finager/screens/splash_screen.dart';
import 'package:finager/screens/settings/settings_screen.dart';
import 'package:finager/screens/analytics_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final rootNavKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/splash',
  navigatorKey: rootNavKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainScreen()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dispatch-transaction',
      builder: (context, state) => const DispatchScreen(),
    ),

    GoRoute(
      path: '/dispatch-detail/:id',
      name: 'dispatch-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DispatchDetailScreen(dispatchId: id);
      },
    ),
    GoRoute(
      path: '/transaction-detail',
      name: 'transaction-detail',
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionEditPage(transaction: transaction);
      },
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/modelSettings',
      builder: (context, state) => const ModelSettings(),
    ),
    GoRoute(
      path: '/transactionform',
      builder: (context, state) {
        final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        return AddTransactionScreen(initialTab: tab);
      },
    ),
  ],
);
