import 'package:finager/components/global_loader.dart';
import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';

abstract class ModelProvider<T> {
  Future<List<T>> getAll();
  Future<bool> delete(List<T> selected);
  String getDisplay(T item);
  Future<T?> showAddEditDialog(BuildContext context, {dynamic initial});
  Future<dynamic> fetchFullData(dynamic item);
  Future<void> showViewDialog(BuildContext context, dynamic item);
}

// Model State
class ModelState<T> {
  final List<T> items;
  final String? error;

  ModelState({required this.items, this.error});

  ModelState<T> copyWith({List<T>? items, bool? isLoading, String? error}) {
    return ModelState(items: items ?? this.items, error: error);
  }

  factory ModelState.initial() => ModelState(items: []);
}

// Notifier
class ModelListNotifier<T> extends StateNotifier<ModelState<T>> {
  final ModelProvider<T> provider;

  ModelListNotifier(this.provider) : super(ModelState.initial()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(error: null);
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final data = await provider.getAll();
      state = state.copyWith(items: data);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Selection state providers
final isSelectingProvider = StateProvider.family<bool, String>(
  (ref, id) => false,
);
final selectedItemsProvider = StateProvider.family<List<dynamic>, String>(
  (ref, id) => [],
);

class ModelListPage<T> extends ConsumerStatefulWidget {
  final String title;
  final ModelProvider<T> provider;

  const ModelListPage({super.key, required this.title, required this.provider});

  @override
  ConsumerState<ModelListPage<T>> createState() => _ModelListPageState<T>();
}

class _ModelListPageState<T> extends ConsumerState<ModelListPage<T>> {
  late final providerFamily =
      StateNotifierProvider.autoDispose<ModelListNotifier<T>, ModelState<T>>(
        (ref) => ModelListNotifier<T>(widget.provider),
      );

  void refresh() => ref.read(providerFamily.notifier).load();

  @override
  Widget build(BuildContext context) {
    final modelState = ref.watch(providerFamily);
    final isSelecting = ref.watch(isSelectingProvider(widget.title));
    final selected = ref.watch(selectedItemsProvider(widget.title));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (isSelecting) ...[
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete),
              // Pressed Function Here
              onPressed: () async {
                GlobalLoader.show(context);
                try {
                  final res = await widget.provider.delete(
                    List<T>.from(selected),
                  );
                  ref.read(selectedItemsProvider(widget.title).notifier).state =
                      [];
                  ref.read(isSelectingProvider(widget.title).notifier).state =
                      false;
                  if (!res) {
                    if (context.mounted) {
                      showMessage(
                        ref: ref,
                        text: AppLocalizations.of(context)!.failedToDelete,
                        backgroundColor: Colors.red,
                        icon: Icons.cancel,
                      );
                    }
                    return;
                  }
                  refresh();
                  if (context.mounted) {
                    showMessage(
                      ref: ref,
                      text:
                          AppLocalizations.of(
                            context,
                          )!.successfullyDeletedTransaction,
                      backgroundColor: Colors.green,
                      icon: Icons.check_circle,
                    );
                  }
                  return;
                } catch (e) {
                  if (context.mounted) {
                    showMessage(
                      ref: ref,
                      text: AppLocalizations.of(context)!.failedToDelete,
                      backgroundColor: Colors.red,
                      icon: Icons.cancel,
                    );
                  }
                } finally {
                  GlobalLoader.hide();
                }
              },
            ),
            IconButton(
              tooltip:
                  selected.length == modelState.items.length
                      ? 'Unselect All'
                      : 'Select All',
              icon: Icon(
                selected.length == modelState.items.length
                    ? Icons.select_all_outlined
                    : Icons.done_all,
              ),
              onPressed: () {
                ref.read(selectedItemsProvider(widget.title).notifier).state =
                    selected.length == modelState.items.length
                        ? []
                        : List<T>.from(modelState.items);
              },
            ),
          ],
          IconButton(
            tooltip: isSelecting ? 'Cancel Selection' : 'Select',
            icon: Icon(isSelecting ? Icons.close : Icons.select_all),
            onPressed: () {
              ref.read(isSelectingProvider(widget.title).notifier).state =
                  !isSelecting;
              if (!ref.read(isSelectingProvider(widget.title))) {
                ref.read(selectedItemsProvider(widget.title).notifier).state =
                    [];
              }
            },
          ),
          IconButton(
            tooltip: 'Add',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await widget.provider.showAddEditDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: modelState.items.length,
              itemBuilder: (_, index) {
                final item = modelState.items[index];
                final isSelected = selected.contains(item);
                return ListTile(
                  title: Text(widget.provider.getDisplay(item)),
                  leading:
                      isSelecting
                          ? Checkbox(
                            value: isSelected,
                            onChanged: (checked) {
                              final notifier = ref.read(
                                selectedItemsProvider(widget.title).notifier,
                              );
                              notifier.state = [
                                ...notifier.state.where((i) => i != item),
                                if (checked ?? false) item,
                              ];
                            },
                          )
                          : null,
                  trailing:
                      isSelecting
                          ? null
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () async {
                                  final fullData = await widget.provider
                                      .fetchFullData(item);
                                  if (context.mounted) {
                                    await widget.provider.showViewDialog(
                                      context,
                                      fullData,
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final fullData = await widget.provider
                                      .fetchFullData(item);
                                  if (context.mounted) {
                                    await widget.provider.showAddEditDialog(
                                      context,
                                      initial: fullData,
                                    );
                                  }
                                  refresh();
                                },
                              ),
                            ],
                          ),
                  onLongPress: () {
                    if (!isSelecting) {
                      ref
                          .read(isSelectingProvider(widget.title).notifier)
                          .state = true;
                      ref
                          .read(selectedItemsProvider(widget.title).notifier)
                          .state = [item];
                    }
                  },
                  onTap:
                      isSelecting
                          ? () {
                            final notifier = ref.read(
                              selectedItemsProvider(widget.title).notifier,
                            );
                            notifier.state =
                                isSelected
                                    ? notifier.state
                                        .where((i) => i != item)
                                        .toList()
                                    : [...notifier.state, item];
                          }
                          : null,
                );
              },
            ),
          ),
          if (modelState.error != null)
            Center(child: Text('Error: ${modelState.error}')),
        ],
      ),
    );
  }
}
