import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class DateTimeField extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const DateTimeField({super.key, this.initialDate});

  @override
  ConsumerState<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends ConsumerState<DateTimeField> {
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
          widget.initialDate!.hour,
          widget.initialDate!.minute,
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
    final borderColor = Colors.indigoAccent.withAlpha(220);

    String formattedDate = MaterialLocalizations.of(
      context,
    ).formatCompactDate(formState.selectedDate.toLocal());
    String formattedTime = TimeOfDay.fromDateTime(
      formState.selectedDate,
    ).format(context);

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
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context)!.pickedTime}: $formattedTime',
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
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.chooseDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => controller.pickTime(context),
                style: TextButton.styleFrom(
                  backgroundColor: borderColor,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.chooseTime,
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
