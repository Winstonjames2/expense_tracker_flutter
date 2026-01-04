import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class DriverField extends ConsumerWidget {
  final String? initialDriver;
  final void Function(String)? onChanged;
  const DriverField({super.key, this.initialDriver, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(transactionFormProvider);
    final borderColor = Colors.indigoAccent.withAlpha(220);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialDriver != null &&
          (formState.driverNameController.text.isEmpty)) {
        formState.driverNameController.text = initialDriver!;
      }
    });

    return TextFormField(
      controller: formState.driverNameController,
      decoration: _inputDecoration(
        AppLocalizations.of(context)!.driver,
        borderColor,
      ),
      maxLines: 1,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value != null) {
          final wordCount = value.trim().split(RegExp(r'\s+')).length;
          if (wordCount > 10) {
            return AppLocalizations.of(
              context,
            )!.max10Words; // Localized error message
          }
        }
        if (value!.length > 200) {
          return AppLocalizations.of(
            context,
          )!.maxCharacterReached; // Localized error message
        }
        return null;
      },
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
