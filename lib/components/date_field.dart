import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class DateField extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const DateField({super.key, this.initialDate});

  @override
  ConsumerState<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends ConsumerState<DateField> {
  bool _initialDateSet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialDateSet && widget.initialDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(transactionFormProvider.notifier);
        final formattedDate = DateTime(
          widget.initialDate!.year,
          widget.initialDate!.month,
          widget.initialDate!.day,
        );
        controller.setDate(formattedDate);

        _initialDateSet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(transactionFormProvider);
    final controller = ref.read(transactionFormProvider.notifier);
    String formattedDate = MaterialLocalizations.of(
      context,
    ).formatCompactDate(formState.selectedDate.toLocal());
    final borderColor = Colors.indigoAccent.withAlpha(220);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.pickedDate}: $formattedDate',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              TextButton(
                onPressed: () => controller.pickDate(context),
                style: TextButton.styleFrom(
                  backgroundColor: borderColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shadowColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.chooseDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
