import 'package:finager/components/global_loader.dart';
import 'package:finager/models/category.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/load_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model_form_dialog.dart';
import 'model_list_page.dart';
import 'package:finager/l10n/app_localizations.dart';

class CategoryProvider {
  final int id;
  final String name;
  CategoryProvider(this.id, this.name);
}

class CategoryModelProvider extends ModelProvider<CategoryProvider> {
  final WidgetRef ref;
  CategoryModelProvider(this.ref);

  @override
  Future<List<CategoryProvider>> getAll() async =>
      ref
          .read(appDataProvider)
          .categories
          .map((e) => CategoryProvider(e.id, e.name))
          .toList();

  @override
  Future<bool> delete(List<CategoryProvider> selected) async {
    bool allPassed = true;
    for (var e in selected) {
      final loadDataProvider = LoadDataProvider();
      final res = await loadDataProvider.deleteModel('category', e.id);
      if (!res) {
        allPassed = false;
      }
    }

    final appData = ref.read(appDataProvider);
    final updatedTrucks = List<Category>.from(appData.categories)
      ..removeWhere((t) => selected.any((sel) => sel.id == t.id));

    ref.read(appDataProvider.notifier).setCategory(updatedTrucks);

    return allPassed;
  }

  @override
  Future<dynamic> fetchFullData(dynamic item) async {
    final id = item.id;
    return ref.read(appDataProvider).categories.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> showViewDialog(BuildContext context, dynamic item) async {
    final appLocal = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(appLocal.categoryDetail),
            content: Text(
              "${appLocal.categoryName}: ${item.name}\n${appLocal.houseExpense}: ${item.isHouseExpense ? appLocal.yes : appLocal.no} \n${appLocal.desc}: ${item.description}",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(appLocal.close),
              ),
            ],
          ),
    );
  }

  @override
  String getDisplay(CategoryProvider item) => item.name;
  @override
  Future<CategoryProvider?> showAddEditDialog(
    BuildContext context, {
    dynamic initial,
  }) {
    final englishController = TextEditingController(text: initial?.name);
    final myanmarController = TextEditingController();
    final chineseController = TextEditingController();
    final descriptionController = TextEditingController(
      text: initial?.description,
    );
    bool isHouseExpense = initial?.isHouseExpense ?? false;
    final appLocal = AppLocalizations.of(context)!;

    return showModelFormDialog<CategoryProvider>(
      context: context,
      form: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: englishController,
                  decoration: InputDecoration(
                    labelText:
                        '${appLocal.categoryName} (${appLocal.english}) *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                if (initial == null)
                  TextField(
                    controller: myanmarController,
                    decoration: InputDecoration(
                      labelText:
                          '${appLocal.categoryName} (${appLocal.myanmar})',
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (initial == null) const SizedBox(height: 12),
                if (initial == null)
                  TextField(
                    controller: chineseController,
                    decoration: InputDecoration(
                      labelText:
                          '${appLocal.categoryName} (${appLocal.chinese})',
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (initial == null) const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: appLocal.description,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: isHouseExpense,
                      onChanged:
                          (val) =>
                              setState(() => isHouseExpense = val ?? false),
                    ),
                    Text(appLocal.houseExpense),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  // Pressed Logic ___________//
                  onPressed: () {
                    GlobalLoader.show(context);
                    final englishName = englishController.text.trim();
                    if (englishName.isEmpty) {
                      showMessage(
                        ref: ref,
                        text: appLocal.errEngRequired,
                        backgroundColor: Colors.red,
                        icon: Icons.cancel,
                      );
                      GlobalLoader.hide();
                      return;
                    }
                    if (myanmarController.text.isEmpty &&
                        chineseController.text.isEmpty &&
                        descriptionController.text.isEmpty &&
                        initial == null) {
                      showMessage(
                        ref: ref,
                        text: appLocal.errMinTransRequired,
                        backgroundColor: Colors.red,
                        icon: Icons.cancel,
                      );
                      GlobalLoader.hide();
                      return;
                    }
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      bool res = false;
                      final loadDataProvider = LoadDataProvider();
                      if (initial != null) {
                        final updatedData = <String, dynamic>{};
                        if (englishName != initial.name) {
                          updatedData['name'] = englishName;
                        }
                        if (descriptionController.text.trim() !=
                            initial.description) {
                          updatedData['description'] =
                              descriptionController.text.trim();
                        }
                        if (isHouseExpense != initial.isHouseExpense) {
                          updatedData['isHouseExpense'] = isHouseExpense;
                        }
                        if (updatedData.isEmpty) {
                          showMessage(
                            ref: ref,
                            text: appLocal.noChangesMade,
                            backgroundColor: Colors.yellow,
                            icon: Icons.warning_rounded,
                          );
                          GlobalLoader.hide();
                          return;
                        }
                        res = await loadDataProvider.updateModel(
                          'category',
                          initial.id,
                          updatedData,
                        );
                      } else {
                        res = await loadDataProvider.addModel('category', {
                          'name': englishName,
                          'description': descriptionController.text.trim(),
                          'isHouseExpense': isHouseExpense,
                          'translated_data': {
                            'field': 'name',
                            'key': englishName,
                            'translations': {
                              'my': myanmarController.text.trim(),
                              'zh': chineseController.text.trim(),
                            },
                          },
                        }, ref);
                      }
                      if (!res) {
                        showMessage(
                          ref: ref,
                          text: appLocal.error,
                          backgroundColor: Colors.red,
                          icon: Icons.cancel,
                        );
                        GlobalLoader.hide();
                        return;
                      }
                      await loadDataProvider.fetchCategories();
                      await ref
                          .read(appDataProvider.notifier)
                          .loadModelPreferencesData();
                      showMessage(
                        ref: ref,
                        text: appLocal.success,
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                      );
                      GlobalLoader.hide();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent.shade700.withAlpha(
                      220,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(appLocal.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
