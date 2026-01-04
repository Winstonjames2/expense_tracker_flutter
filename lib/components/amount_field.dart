import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class AmountField extends ConsumerWidget {
  final double? initialAmount;
  final String? amountLabel;

  const AmountField({super.key, this.initialAmount, this.amountLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(transactionFormProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialAmount != null && formState.amountController.text.isEmpty) {
        formState.amountController.text = initialAmount!.toString();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: formState.amountController,
          decoration: _inputDecoration(
            AppLocalizations.of(context)!.amount,
          ).copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel_outlined),
              iconSize: 30,
              color: Colors.red,
              onPressed: () {
                formState.amountController.clear();
              },
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterAmount;
            }
            final amt = double.tryParse(value);
            if (amt == null || amt <= 0) {
              return AppLocalizations.of(context)!.numberMustBePositive;
            }
            if (value.split('.').first.length > 10) {
              return AppLocalizations.of(context)!.max10Digits;
            }
            if (!RegExp(r'^\d+$').hasMatch(value.split('.').first)) {
              return AppLocalizations.of(context)!.onlyDigits;
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var amount in [10, 50, 1000, 5000, 10000])
              _buildAmountButton(context, formState, amount),
            _buildZeroButton(context, formState, multiplier: 10, label: '+0'),
            _buildZeroButton(context, formState, multiplier: 100, label: '+00'),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountButton(
    BuildContext context,
    dynamic formState,
    int value,
  ) {
    return ElevatedButton(
      onPressed: () {
        final currentText = formState.amountController.text;
        final currentValue = double.tryParse(currentText) ?? 0.0;
        final newValue = currentValue + value;
        formState.amountController.text = newValue.toStringAsFixed(0);
      },
      style: _buttonStyle(bgColor: Colors.indigoAccent.withAlpha(220)),
      child: Text('+$value'),
    );
  }

  Widget _buildZeroButton(
    BuildContext context,
    dynamic formState, {
    required int multiplier,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: () {
        final currentText = formState.amountController.text;
        final currentValue = double.tryParse(currentText) ?? 0.0;
        if (currentValue > 0) {
          final newValue = currentValue * multiplier;
          formState.amountController.text = newValue.toStringAsFixed(0);
        }
      },
      style: _buttonStyle(bgColor: Colors.deepPurple.withAlpha(220)),
      child: Text(label),
    );
  }

  ButtonStyle _buttonStyle({Color? bgColor}) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: bgColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: const TextStyle(fontSize: 14),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: amountLabel ?? label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.indigoAccent.withAlpha(220)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.indigoAccent.withAlpha(220),
          width: 2.0,
        ),
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
