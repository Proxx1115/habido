import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../assets.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    brightness: Brightness.light,
    fontFamily: FontAssets.FiraSansCondensed,
    primarySwatch: MaterialColor(
      0xFF24ABF8,
      <int, Color>{
        50: Color(0xfffa6c51),
        100: Color(0xfffa6c51),
        200: Color(0xfffa6c51),
        300: Color(0xfffa6c51),
        400: Color(0xfffa6c51),
        500: Color(0xfffa6c51),
        600: Color(0xfffa6c51),
        700: Color(0xfffa6c51),
        800: Color(0xfffa6c51),
        900: Color(0xfffa6c51),
      },
    ),
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: Colors.black),
    brightness: Brightness.dark,
    fontFamily: FontAssets.FiraSansCondensed,
    primarySwatch: MaterialColor(
      0xFF24ABF8,
      <int, Color>{
        50: Color(0xfffa6c51),
        100: Color(0xfffa6c51),
        200: Color(0xfffa6c51),
        300: Color(0xfffa6c51),
        400: Color(0xfffa6c51),
        500: Color(0xfffa6c51),
        600: Color(0xfffa6c51),
        700: Color(0xfffa6c51),
        800: Color(0xfffa6c51),
        900: Color(0xfffa6c51),
      },
    ),
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
