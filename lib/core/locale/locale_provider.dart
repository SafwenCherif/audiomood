import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr')) {
    _load();
  }

  static const supportedLocales = [Locale('en'), Locale('fr')];

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == 'en') {
      state = const Locale('en');
    } else if (code == 'fr') {
      state = const Locale('fr');
    } else {
      final device = WidgetsBinding.instance.platformDispatcher.locale;
      state = device.languageCode == 'en'
          ? const Locale('en')
          : const Locale('fr');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'fr') return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr');
    await setLocale(next);
  }
}
