import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/locale/locale_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final isFrench = locale.languageCode == 'fr';

    if (compact) {
      return SegmentedButton<bool>(
        segments: [
          ButtonSegment(value: false, label: Text(l10n.languageEnglish)),
          ButtonSegment(value: true, label: Text(l10n.languageFrench)),
        ],
        selected: {isFrench},
        onSelectionChanged: (selected) {
          final french = selected.first;
          ref
              .read(localeProvider.notifier)
              .setLocale(Locale(french ? 'fr' : 'en'));
        },
      );
    }

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: DropdownButton<Locale>(
        value: locale,
        underline: const SizedBox.shrink(),
        items: [
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(l10n.languageEnglish),
          ),
          DropdownMenuItem(
            value: const Locale('fr'),
            child: Text(l10n.languageFrench),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            ref.read(localeProvider.notifier).setLocale(value);
          }
        },
      ),
    );
  }
}
