import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_form_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class DescriptionField extends ConsumerWidget {
  final String? initialDescription;
  const DescriptionField({super.key, this.initialDescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(transactionFormProvider);
    final borderColor = Colors.indigoAccent.withAlpha(220);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialDescription != null &&
          formState.descriptionController.text.isEmpty) {
        formState.descriptionController.text = initialDescription!;
      }
    });
    return TextFormField(
      controller: formState.descriptionController,
      decoration: _inputDecoration(
        AppLocalizations.of(context)!.description,
        borderColor,
      ),
      maxLines: 1,
      validator: (value) {
        if (value != null) {
          final wordCount = value.trim().split(RegExp(r'\s+')).length;
          if (wordCount > 20) {
            return AppLocalizations.of(
              context,
            )!.max20Words; // Localized error message
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
