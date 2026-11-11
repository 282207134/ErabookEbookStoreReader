import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'data/app_state.dart';

class ErabookApp extends StatelessWidget {
  const ErabookApp({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AppState.instance,
    builder: (context, _) => MaterialApp(
      title: 'Erabook',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: AppState.instance.themeMode,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle(Theme.brightnessOf(context)),
        child: child!,
      ),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    ),
  );
}
