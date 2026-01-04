import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:finager/providers/message_provider.dart';

class TransactionFilterDialog extends ConsumerStatefulWidget {
  const TransactionFilterDialog({super.key});

  @override
  ConsumerState<TransactionFilterDialog> createState() =>
      TransactionFilterDialogState();
}

class TransactionFilterDialogState
    extends ConsumerState<TransactionFilterDialog> {
  DateTime? _from;
  DateTime? _to;
  int? _categoryId;

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final categories = ref.watch(appDataProvider).categories;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                appLocal.filterBy,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: colorScheme.primary.withAlpha(100),
                      ),
                    ),
                    onPressed: () => _pickDate(context, true),
                    label: Text(
                      _from == null
                          ? appLocal.startDate
                          : DateFormat.yMd().format(_from!),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: colorScheme.primary.withAlpha(100),
                      ),
                    ),
                    onPressed: () => _pickDate(context, false),
                    label: Text(
                      _to == null
                          ? appLocal.endDate
                          : DateFormat.yMd().format(_to!),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: appLocal.category,
                labelStyle: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: colorScheme.surface.withAlpha(20),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigoAccent.withAlpha(220),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.primary.withAlpha(100),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: colorScheme.surface,
              value: _categoryId,
              items:
                  categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(
                            cat.name,
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _categoryId = val),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurface.withAlpha(180),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(appLocal.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    if (_from == null && _to == null && _categoryId == null) {
                      showMessage(
                        ref: ref,
                        text: AppLocalizations.of(context)!.noFilterSelected,
                        backgroundColor: Colors.yellow,
                        icon: Icons.warning,
                      );
                      return;
                    }

                    Navigator.of(
                      context,
                    ).pop({'from': _from, 'to': _to, 'category': _categoryId});
                  },
                  label: Text(appLocal.apply),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.indigoAccent.withAlpha(220),
                ),
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
  }
}
