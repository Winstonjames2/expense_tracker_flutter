import 'package:finager/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finager/core/routes.dart';
import 'package:finager/providers/app_init_provider.dart';
import 'package:finager/l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInit = ref.watch(appInitProvider);
    final fontSize = appInit.fontSize;

    final baseTextTheme = TextTheme(
      bodyLarge: TextStyle(fontSize: fontSize + 1),
      bodyMedium: TextStyle(fontSize: fontSize),
      displayMedium: TextStyle(
        fontSize: fontSize + 2,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: fontSize + 4,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(fontSize: fontSize, fontWeight: FontWeight.normal),
      titleSmall: TextStyle(
        fontSize: fontSize - 2,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(fontSize: fontSize - 1),
      labelMedium: TextStyle(
        fontSize: fontSize - 3.5,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: fontSize - 4.5,
        fontWeight: FontWeight.w500,
      ),
    );

    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigoAccent.withAlpha(220),
        primary: Colors.indigoAccent.shade400.withAlpha(220),
        onPrimary: Colors.white,
        tertiary: Colors.black.withAlpha(220),
      ),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.indigoAccent.withAlpha(220),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigoAccent.withAlpha(220),
        foregroundColor: Colors.white,
      ),
      textTheme: baseTextTheme,
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigoAccent.withAlpha(220),
        primary: Colors.indigoAccent.shade100.withAlpha(220),
        secondary: Colors.indigoAccent.withAlpha(220),
        onPrimary: Colors.white,
        brightness: Brightness.dark,
        tertiary: Colors.white.withAlpha(220),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(231, 0, 6, 20),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigoAccent.withAlpha(220),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: Colors.black54,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.indigoAccent.shade100.withAlpha(50),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.indigoAccent.shade400,
        selectionColor: Colors.indigoAccent.shade700,
        selectionHandleColor: Colors.indigoAccent.shade400,
      ),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(149, 0, 0, 0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.indigoAccent.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textTheme: baseTextTheme.copyWith(
        bodyMedium: TextStyle(fontSize: fontSize, color: Colors.white),
        bodyLarge: TextStyle(fontSize: fontSize + 1, color: Colors.white),
        titleLarge: TextStyle(
          fontSize: fontSize + 4,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: fontSize + 1,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        titleSmall: TextStyle(fontSize: fontSize, color: Colors.white),
        labelMedium: TextStyle(
          fontSize: fontSize - 2,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: fontSize - 4,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Finager',
      themeMode: appInit.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      locale: appInit.locale,
      supportedLocales: const [Locale('en'), Locale('my'), Locale('zh')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
