import 'package:finager/screens/transaction_history/transaction_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/models/category.dart';
import 'package:finager/models/transaction.dart';
import 'package:finager/providers/app_data_provider.dart';

class CategoryAnalytics {
  final Category category;
  final double total;

  CategoryAnalytics({required this.category, required this.total});
}

// Generalized provider using family for both household and truck analytics
class CategoryAnalyticsArgs {
  final bool isHouseExpense;
  final String outcomeLabel;

  CategoryAnalyticsArgs({
    required this.isHouseExpense,
    required this.outcomeLabel,
  });
}

final categoryAnalyticsProvider =
    Provider.family<List<CategoryAnalytics>, CategoryAnalyticsArgs>((
      ref,
      args,
    ) {
      final state = ref.watch(transactionDataProvider);
      final appState = ref.watch(appDataProvider);

      final categories =
          appState.categories
              .where((c) => c.isHouseExpense == args.isHouseExpense)
              .toList();

      final transactions =
          state.transactions
              .where(
                (tx) =>
                    tx.transactionType.trim().toLowerCase() ==
                    args.outcomeLabel.trim().toLowerCase(),
              )
              .toList();

      return _groupTransactionsByCategory(categories, transactions);
    });

List<CategoryAnalytics> _groupTransactionsByCategory(
  List<Category> categories,
  List<Transaction> transactions,
) {
  final Map<int, double> categoryTotals = {};

  for (final tx in transactions) {
    final txCategoryId = tx.category;
    final matchedCategory = categories.firstWhere(
      (cat) => cat.id == txCategoryId,
      orElse: () => Category(id: -1, name: 'Unknown', isHouseExpense: true),
    );

    if (matchedCategory.id != -1) {
      final currentTotal = categoryTotals[matchedCategory.id] ?? 0.0;
      categoryTotals[matchedCategory.id] = currentTotal + tx.amount;
    }
  }

  final List<CategoryAnalytics> result =
      categories
          .where((cat) => categoryTotals.containsKey(cat.id))
          .map(
            (cat) => CategoryAnalytics(
              category: cat,
              total: categoryTotals[cat.id]!,
            ),
          )
          .toList();

  return result;
}
