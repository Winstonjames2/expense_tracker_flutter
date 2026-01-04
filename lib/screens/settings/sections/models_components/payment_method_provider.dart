import 'package:finager/components/global_loader.dart';
import 'package:finager/models/payment_method.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/load_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model_form_dialog.dart';
import 'model_list_page.dart';
import 'package:finager/l10n/app_localizations.dart';

class PaymentMethodProvider {
  final int id;
  final String name;
  PaymentMethodProvider(this.id, this.name);
}

class PaymentMethodModelProvider extends ModelProvider<PaymentMethodProvider> {
  final WidgetRef ref;
  PaymentMethodModelProvider(this.ref);

  @override
  Future<List<PaymentMethodProvider>> getAll() async =>
      ref
          .read(appDataProvider)
          .paymentMethods
          .map((e) => PaymentMethodProvider(e.id, e.name))
          .toList();

  @override
  Future<bool> delete(List<PaymentMethodProvider> selected) async {
    bool allPassed = true;
    for (var e in selected) {
      final loadDataProvider = LoadDataProvider();
      final res = await loadDataProvider.deleteModel('payment-method', e.id);
      if (!res) {
        allPassed = false;
      }
    }

    final appData = ref.read(appDataProvider);
    final updatedTrucks = List<PaymentMethod>.from(appData.paymentMethods)
      ..removeWhere((t) => selected.any((sel) => sel.id == t.id));

    ref.read(appDataProvider.notifier).setPaymentMethod(updatedTrucks);

    return allPassed;
  }

  @override
  String getDisplay(PaymentMethodProvider item) => item.name;

  @override
  Future<dynamic> fetchFullData(dynamic item) async {
    final id = item.id;
    return ref
        .read(appDataProvider)
        .paymentMethods
        .firstWhere((t) => t.id == id);
  }

  @override
  Future<void> showViewDialog(BuildContext context, item) async {
    final appLocal = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(appLocal.paymentMethodDetail),
            content: Text(
              "${appLocal.paymentMethod}: ${item.name}\n${appLocal.desc}: ${item.description}",
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
  Future<PaymentMethodProvider?> showAddEditDialog(
    BuildContext context, {
    dynamic initial,
  }) {
    final enController = TextEditingController(text: initial?.name);
    final myController = TextEditingController();
    final cnController = TextEditingController();
    final descController = TextEditingController(text: initial?.description);
    final appLocal = AppLocalizations.of(context)!;

    return showModelFormDialog(
      context: context,
      form: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            appLocal.addPaymentMethod,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: enController,
            decoration: InputDecoration(
              labelText: '${appLocal.paymentMethod} (${appLocal.english}) *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (initial == null)
            TextField(
              controller: myController,
              decoration: InputDecoration(
                labelText: '${appLocal.paymentMethod} (${appLocal.myanmar})',
                border: OutlineInputBorder(),
              ),
            ),
          if (initial == null) const SizedBox(height: 16),
          if (initial == null)
            TextField(
              controller: cnController,
              decoration: InputDecoration(
                labelText: '${appLocal.paymentMethod} (${appLocal.chinese})',
                border: OutlineInputBorder(),
              ),
            ),
          if (initial == null) const SizedBox(height: 16),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              labelText: appLocal.description,
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          // Pressed Logic ___________//
          ElevatedButton(
            onPressed: () {
              GlobalLoader.show(context);
              final englishName = enController.text.trim();
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
              if (myController.text.isEmpty &&
                  cnController.text.isEmpty &&
                  descController.text.isEmpty &&
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
                bool res;
                final loadDataProvider = LoadDataProvider();
                if (initial != null) {
                  final updatedData = <String, dynamic>{};
                  if (englishName != initial.name) {
                    updatedData['name'] = englishName;
                  }
                  if (descController.text.trim() != initial.description) {
                    updatedData['description'] = descController.text.trim();
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
                    'payment-method',
                    initial.id,
                    updatedData,
                  );
                } else {
                  res = await loadDataProvider.addModel('payment-method', {
                    'name': englishName,
                    'description': descController.text.trim(),
                    'translated_data': {
                      'field': 'name',
                      'key': englishName,
                      'translations': {
                        'my': myController.text.trim(),
                        'zh': cnController.text.trim(),
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
                await loadDataProvider.fetchPaymentMethods();
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
              backgroundColor: Colors.indigoAccent.shade700.withAlpha(220),
              foregroundColor: Colors.white,
            ),
            child: Text(appLocal.save),
          ),
        ],
      ),
    );
  }
}
