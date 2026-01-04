import 'package:finager/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/services/preferences_service.dart';

// AppInitState: represents the state
class AppInitState {
  final bool hasMore;
  final Locale locale;
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;

  AppInitState({
    required this.hasMore,
    required this.locale,
    required this.themeMode,
    required this.fontSize,
    required this.fontFamily,
  });

  AppInitState copyWith({
    bool? hasMore,
    Locale? locale,
    ThemeMode? themeMode,
    double? fontSize,
    String? fontFamily,
  }) {
    return AppInitState(
      hasMore: hasMore ?? this.hasMore,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

// AppInitNotifier: manages AppInitState
class AppInitNotifier extends StateNotifier<AppInitState> {
  final Ref ref;

  AppInitNotifier(this.ref)
    : super(
        AppInitState(
          hasMore: true,
          locale: const Locale('en'),
          themeMode: ThemeMode.light,
          fontSize: 0.0,
          fontFamily: 'Arial',
        ),
      ) {
    _loadPreferences();
  }

  final PreferencesService _prefsService = PreferencesService();

  Future<void> _loadPreferences() async {
    final locale = await _prefsService.loadLocale();
    final fontSize = await _prefsService.loadFontSize();
    final fontFamily = await _prefsService.loadFontFamily();
    final theme = await _prefsService.loadThemeMode();

    state = state.copyWith(
      locale: locale,
      fontSize: fontSize,
      fontFamily: fontFamily,
      themeMode: theme,
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _prefsService.saveLocale(locale);
    await ref.read(appDataProvider.notifier).loadData(mustLoadBackend: true);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _prefsService.saveThemeMode(themeMode);
  }

  Future<void> setFontSize(double fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _prefsService.saveFontsize(fontSize);
  }
}

// Riverpod provider
final appInitProvider = StateNotifierProvider<AppInitNotifier, AppInitState>(
  (ref) => AppInitNotifier(ref),
);
