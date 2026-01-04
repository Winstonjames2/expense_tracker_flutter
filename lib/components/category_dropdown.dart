import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class CategoryDropdown extends ConsumerWidget {
  final bool isHouseholdForm;
  final int? initialCategory;

  const CategoryDropdown({
    super.key,
    required this.isHouseholdForm,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(transactionFormProvider);
    final provider = ref.read(transactionFormProvider.notifier);
    final appState = ref.read(appDataProvider);

    final borderColor = Colors.indigoAccent.withAlpha(220);
    final filteredCategories =
        appState.categories
            .where(
              (category) =>
                  ((isHouseholdForm && category.isHouseExpense) ||
                      (!isHouseholdForm && !category.isHouseExpense)),
            )
            .toList();

    Category? selectedCategory;
    if (initialCategory != null && initialCategory != null) {
      selectedCategory = appState.categories.firstWhere(
        (category) => category.id == initialCategory,
        orElse: () => Category(id: 0, name: 'Error', isHouseExpense: false),
      );
    } else if (formState.selectedCategory != null) {
      selectedCategory = appState.categories.firstWhere(
        (category) => category.id == formState.selectedCategory,
        orElse: () => Category(id: 0, name: 'Error', isHouseExpense: false),
      );
    }

    return DropdownButtonFormField<Category>(
      decoration: _inputDecoration(
        AppLocalizations.of(context)!.category,
        borderColor,
      ),
      value:
          filteredCategories.contains(selectedCategory)
              ? selectedCategory
              : null,
      onChanged: (Category? newValue) {
        if (newValue != null) {
          provider.setSelectedCategory(newValue.id);
        }
      },
      items:
          filteredCategories.map<DropdownMenuItem<Category>>((category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
      validator:
          (value) =>
              value == null
                  ? AppLocalizations.of(context)!.pleaseSelectCategory
                  : null,
    );
  }

  InputDecoration _inputDecoration(String label, borderColor) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    );
  }
}
