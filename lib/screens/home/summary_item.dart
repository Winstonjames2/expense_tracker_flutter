import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final Color textColor;
  final String title;
  final String amount;

  const SummaryItem({
    super.key,
    required this.textColor,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.colorScheme.onSurfaceVariant; // subtle text color

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(color: titleColor),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
