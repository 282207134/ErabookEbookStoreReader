import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Design tokens extracted from the Pixso "Erabook" Design System page.
class C {
  static const primary = Color(0xFFF89300);
  static const primaryDark = Color(0xFFC67600);
  static const secondary = Color(0xFFFFC107);
  static const success = Color(0xFF12D18E);
  static const info = Color(0xFF246BFD);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFF75555);
  static const purple = Color(0xFF6949FF);
  static const teal = Color(0xFF019B83);
  static const red = Color(0xFFFF5A5F);

  static const g900 = Color(0xFF212121);
  static const g800 = Color(0xFF424242);
  static const g700 = Color(0xFF616161);
  static const g600 = Color(0xFF757575);
  static const g500 = Color(0xFF9E9E9E);
  static const g400 = Color(0xFFBDBDBD);
  static const g300 = Color(0xFFE0E0E0);
  static const g200 = Color(0xFFEEEEEE);
  static const g100 = Color(0xFFF5F5F5);
  static const g50 = Color(0xFFFAFAFA);

  static const dark1 = Color(0xFF181A20);
  static const dark2 = Color(0xFF1F222A);
  static const dark4 = Color(0xFF35383F);

  static const bgOrange = Color(0xFFFFF8EE);
  static const bgGreen = Color(0xFFF1FDF5);
  static const bgBlue = Color(0xFFF6F9FF);
  static const bgPurple = Color(0xFFF9F8FF);
  static const bgRed = Color(0xFFFFF7F8);
}

double _wght(FontWeight w) => w.value.toDouble();

/// Urbanist is a variable font; map FontWeight onto the `wght` axis.
TextStyle ts(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = C.g900,
  double? height,
  double letterSpacing = 0,
}) => TextStyle(
  fontFamily: 'Urbanist',
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: letterSpacing,
  fontVariations: [FontVariation('wght', _wght(weight))],
);

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final bg = dark ? C.dark1 : Colors.white;
  final surface = dark ? C.dark2 : Colors.white;
  final text = dark ? Colors.white : C.g900;
  return ThemeData(
    brightness: b,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.primary,
      brightness: b,
      primary: C.primary,
      surface: surface,
    ),
    fontFamily: 'Urbanist',
    splashFactory: NoSplash.splashFactory,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      modalBackgroundColor: surface,
      surfaceTintColor: Colors.transparent,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: surface,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      fillColor: dark ? C.dark2 : C.g50,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: overlayStyle(b),
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: text),
      titleTextStyle: ts(24, weight: FontWeight.w700, color: text),
    ),
    dividerTheme: DividerThemeData(
      color: dark ? C.dark4 : C.g200,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : C.g400,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? C.primary : C.g300,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: C.primary),
  );
}

SystemUiOverlayStyle overlayStyle(Brightness brightness) =>
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );
