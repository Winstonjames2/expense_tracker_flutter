import 'package:finager/models/payment_method.dart';
import 'package:finager/models/truck.dart';
import 'package:finager/models/category.dart';
import 'package:finager/models/account.dart';
import 'package:finager/providers/load_data_provider.dart';
import 'package:finager/providers/stats_provider.dart';
import 'package:finager/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDataProvider = StateNotifierProvider<AppDataNotifier, AppDataState>((
  ref,
) {
  final appDataNotifier = AppDataNotifier(ref);
  return appDataNotifier;
});

class AppDataState {
  final List<Account> accounts;
  final List<Category> categories;
  final List<PaymentMethod> paymentMethods;
  final List<Truck> trucks;
  final bool isLoading;
  final StatsData statsData;
  AppDataState({
    List<Account>? accounts,
    List<Category>? categories,
    List<PaymentMethod>? paymentMethods,
    List<Truck>? trucks,
    StatsData? statsData,
    this.isLoading = false,
  }) : accounts = accounts ?? const [],
       categories = categories ?? const [],
       paymentMethods = paymentMethods ?? const [],
       trucks = trucks ?? const [],
       statsData = statsData ?? StatsData.empty();

  AppDataState copyWith({
    List<Account>? accounts,
    List<Category>? categories,
    List<PaymentMethod>? paymentMethods,
    List<Truck>? trucks,
    bool? isLoading,
    StatsData? statsData,
  }) {
    return AppDataState(
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      trucks: trucks ?? this.trucks,
      isLoading: isLoading ?? this.isLoading,
      statsData: statsData ?? this.statsData,
    );
  }
}

class AppDataNotifier extends StateNotifier<AppDataState> {
  final Ref ref;

  AppDataNotifier(this.ref)
    : super(
        AppDataState(
          accounts: const [],
          categories: const [],
          paymentMethods: const [],
          trucks: const [],
          isLoading: false,
        ),
      ) {
    refreshHomePage();
    loadData();
  }

  final loadDataProvider = LoadDataProvider();

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  Future<void> refreshHomePage() async {
    try {
      state = state.copyWith(isLoading: true);
      final accountData = await loadDataProvider.fetchAccounts();
      final statsData = await loadDataProvider.fetchStatsData();
      state = state.copyWith(accounts: accountData, statsData: statsData);
    } catch (e) {
      debugPrint("error at retrieving homepage data $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<T>> _fetchOrLoadFromPreferences<T>({
    required Future<List<T>> Function() fetchFromBackend,
    required Future<List<T>?> Function() loadFromPreferences,
    required bool mustLoadBackend,
  }) async {
    final prefsData = await loadFromPreferences();
    if (!mustLoadBackend) {
      if (prefsData != null && prefsData.isNotEmpty) {
        return prefsData;
      }
    }
    return await fetchFromBackend();
  }

  Future<bool> refreshTransactions() async {
    return await loadDataProvider.recalculateAllTransactions();
  }

  Future<void> loadData({mustLoadBackend = false}) async {
    state = state.copyWith(isLoading: true);
    final prefs = PreferencesService();
    if (!mustLoadBackend) {
      final needUpdate = await loadDataProvider.needUpdatingData();
      if (needUpdate) {
        mustLoadBackend = true;
      }
    }

    // Fetch or load other data based on backend update status
    final categoriesData = await _fetchOrLoadFromPreferences(
      fetchFromBackend: () => loadDataProvider.fetchCategories(),
      loadFromPreferences: prefs.loadCategoryData,
      mustLoadBackend: mustLoadBackend,
    );

    final paymentMethodsData = await _fetchOrLoadFromPreferences(
      fetchFromBackend: () => loadDataProvider.fetchPaymentMethods(),
      loadFromPreferences: prefs.loadPaymentMethodData,
      mustLoadBackend: mustLoadBackend,
    );

    final trucksData = await _fetchOrLoadFromPreferences(
      fetchFromBackend: () => loadDataProvider.fetchTrucks(),
      loadFromPreferences: prefs.loadTruckData,
      mustLoadBackend: mustLoadBackend,
    );

    state = state.copyWith(
      categories: categoriesData,
      paymentMethods: paymentMethodsData,
      trucks: trucksData,
    );
    state = state.copyWith(isLoading: false);
  }

  Future<void> loadModelPreferencesData() async {
    final prefs = PreferencesService();
    final categories = await prefs.loadCategoryData();
    final paymentMethods = await prefs.loadPaymentMethodData();
    final trucks = await prefs.loadTruckData();

    state = state.copyWith(
      categories: categories ?? state.categories,
      paymentMethods: paymentMethods ?? state.paymentMethods,
      trucks: trucks ?? state.trucks,
    );
  }

  void setTruck(newList) {
    state = state.copyWith(trucks: newList);
  }

  void setCategory(newList) {
    state = state.copyWith(categories: newList);
  }

  void setPaymentMethod(newList) {
    state = state.copyWith(paymentMethods: newList);
  }
}
