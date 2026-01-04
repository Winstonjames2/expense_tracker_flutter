import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/l10n/app_localizations.dart';
import '../../../providers/app_init_provider.dart';

class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocal = AppLocalizations.of(context)!;
    final appInit = ref.watch(appInitProvider);

    return Column(
      children: [
        ListTile(
          title: Text(appLocal.changeLanguage),
          trailing: DropdownButton<String>(
            value: appInit.locale.languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'my', child: Text('Burmese')),
              DropdownMenuItem(value: 'zh', child: Text('Chinese')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(appInitProvider.notifier).setLocale(Locale(value));
              }
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.font_download_outlined),
          title: Text(appLocal.font),
          subtitle: Slider(
            activeColor: Colors.indigoAccent.withAlpha(220),
            value: appInit.fontSize,
            min: 14,
            max: 18,
            divisions: 4,
            label: appInit.fontSize.toStringAsFixed(1),
            onChanged:
                (val) => ref.read(appInitProvider.notifier).setFontSize(val),
          ),
        ),
      ],
    );
  }
}
