// lib/providers/message_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/core/routes.dart'; // ← for rootNavKey

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Message data class
class MessageData {
  final String text;
  final Color backgroundColor;
  final IconData icon;

  MessageData({
    required this.text,
    this.backgroundColor = Colors.blue,
    this.icon = Icons.info,
  });
}

/// Notifier doesn’t actually need to hold state for this pattern,
/// but we keep it to satisfy your existing API.
class MessageNotifier extends StateNotifier<MessageData?> {
  MessageNotifier() : super(null);

  void show({
    required String text,
    Color backgroundColor = Colors.blue,
    IconData icon = Icons.info,
  }) {
    final ctx = rootNavKey.currentContext;
    if (ctx == null) return;

    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Fade + Slide animation
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2), // start 20% down
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder:
          (_, __, ___) => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (ctx.mounted) if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
    });
  }

  void clear() => state = null;
}

/// Provider remains the same
final messageProvider = StateNotifierProvider<MessageNotifier, MessageData?>((
  ref,
) {
  return MessageNotifier();
});

/// Helper stays the same
void showMessage({
  required WidgetRef ref,
  required String text,
  Color backgroundColor = Colors.blue,
  IconData icon = Icons.info,
}) {
  ref
      .read(messageProvider.notifier)
      .show(text: text, backgroundColor: backgroundColor, icon: icon);
}
