import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'sections/account_section.dart';
import 'sections/general_section.dart';
import 'sections/app_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocal.settings),
        backgroundColor: Colors.indigoAccent.withAlpha(220),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          SectionTitle(title: appLocal.account),
          const AccountSection(),

          const SizedBox(height: 8),
          SectionTitle(title: appLocal.language),
          const GeneralSection(),

          const SizedBox(height: 16),
          SectionTitle(title: appLocal.appSettings),
          const AppSection(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: Colors.indigoAccent),
      ),
    );
  }
}
