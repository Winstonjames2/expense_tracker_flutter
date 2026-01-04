import 'package:flutter/material.dart';

Future<T?> showModelFormDialog<T>({
  required BuildContext context,
  required Widget form,
}) {
  return showDialog<T>(
    context: context,
    builder:
        (_) => AlertDialog(
          content: form,
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
  );
}
