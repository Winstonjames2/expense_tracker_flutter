import 'package:flutter/material.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupButtonsSection extends ConsumerWidget {
  const PopupButtonsSection({super.key});

  List<PopupButtonData> _buildButtons(BuildContext context, WidgetRef ref) => [
    PopupButtonData(
      icon: Icons.local_shipping,
      label: AppLocalizations.of(context)!.dispatch,
      onPressed: () {
        GoRouter.of(context).push('/dispatch-transaction');
      },
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children:
            _buildButtons(
              context,
              ref,
            ).map((btn) => _buildButton(context, btn)).toList(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, PopupButtonData btn) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(btn.icon, size: 22, color: colorScheme.primary),
        label: Text(
          btn.label,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark ? colorScheme.surface : Colors.white.withAlpha(220),
          shadowColor: Colors.black26,
          elevation: 4,
          side: BorderSide(
            color: colorScheme.primary.withAlpha(140),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: btn.onPressed,
      ),
    );
  }
}

class PopupButtonData {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const PopupButtonData({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
