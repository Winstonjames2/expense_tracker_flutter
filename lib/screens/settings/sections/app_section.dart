import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/app_init_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class AppSection extends ConsumerWidget {
  const AppSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInit = ref.watch(appInitProvider);
    final appLocal = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          tileColor: const Color.fromARGB(36, 0, 66, 181),
          leading: Icon(Icons.dataset_outlined),
          title: Text(appLocal.modelSettings),
          onTap: () {
            GoRouter.of(context).push('/modelSettings');
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: Text(appLocal.theme),
          trailing: DropdownButton<ThemeMode>(
            value: appInit.themeMode,
            items: const [
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            ],
            onChanged:
                (val) => ref.read(appInitProvider.notifier).setTheme(val!),
          ),
        ),

        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(appLocal.privacyPolicy),
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text(appLocal.privacyPolicy),
                    content: Text(
                      appLocal.privacyPolicyContent,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(appLocal.contactSupport),
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text(appLocal.contactSupport),
                    content: Text(appLocal.contactSupportMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          },
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("Version 1.0.0"),
        ),
      ],
    );
  }
}
