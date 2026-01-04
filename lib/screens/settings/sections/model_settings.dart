import 'package:finager/components/global_loader.dart';
import 'package:finager/providers/app_data_provider.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models_components/model_list_page.dart';
import 'models_components/truck_provider.dart';
import 'models_components/payment_method_provider.dart';
import 'models_components/category_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class ModelSettings extends ConsumerWidget {
  const ModelSettings({super.key});

  Future<void> _refreshAllTransaction(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final appLocal = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              appLocal.confirm,
              style: TextStyle(color: Colors.indigoAccent),
            ),
            content: Text('Verify & Recalculate All Transactions'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  appLocal.cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.indigoAccent.withAlpha(220),
                  foregroundColor: Colors.white,
                ),
                onPressed:
                    () => {
                      Navigator.of(ctx).pop(true),
                      GlobalLoader.show(context),
                    },
                child: Text('Recalculate'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final res =
          await ref.read(appDataProvider.notifier).refreshTransactions();
      if (res) {
        showMessage(
          ref: ref,
          text: appLocal.success,
          icon: Icons.check_circle,
          backgroundColor: Colors.green,
        );
      } else {
        showMessage(
          ref: ref,
          text: appLocal.error,
          icon: Icons.cancel,
          backgroundColor: Colors.red,
        );
      }
      GlobalLoader.hide();
    }
  }

  Future<void> _refreshAllModels(BuildContext context, WidgetRef ref) async {
    final appLocal = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              appLocal.confirmRefresh,
              style: TextStyle(color: Colors.indigoAccent),
            ),
            content: Text(appLocal.confirmRefreshMsg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  appLocal.cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.indigoAccent.withAlpha(220),
                  foregroundColor: Colors.white,
                ),
                onPressed:
                    () => {
                      Navigator.of(ctx).pop(true),
                      GlobalLoader.show(context),
                    },
                child: Text(appLocal.refresh),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await ref.read(appDataProvider.notifier).loadData(mustLoadBackend: true);
      showMessage(
        ref: ref,
        text: appLocal.successRefreshMsg,
        icon: Icons.check_circle,
        backgroundColor: Colors.green,
      );
      GlobalLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocal.modelSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: appLocal.refreshTip,
            onPressed: () {
              _refreshAllTransaction(context, ref);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: appLocal.refreshTip,
            onPressed: () {
              _refreshAllModels(context, ref);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(appLocal.truck),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ModelListPage(
                          title: appLocal.truck,
                          provider: TruckModelProvider(ref),
                        ),
                  ),
                ),
          ),
          ListTile(
            title: Text(appLocal.paymentMethod),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ModelListPage(
                          title: appLocal.paymentMethod,
                          provider: PaymentMethodModelProvider(ref),
                        ),
                  ),
                ),
          ),
          ListTile(
            title: Text(appLocal.category),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ModelListPage(
                          title: appLocal.category,
                          provider: CategoryModelProvider(ref),
                        ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
