import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing the application's [ThemeMode].
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Toggles between light and dark modes.
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
