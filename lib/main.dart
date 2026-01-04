import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finager/core/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setting system UI overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}
