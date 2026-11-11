import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/core/theme/app_theme.dart';
import 'src/presentation/bloc/theme/theme_cubit.dart';
import 'src/presentation/bloc/transliterator/transliterator_bloc.dart';
import 'src/presentation/pages/transliterator_page.dart';

void main() {
  runApp(const TransliteratorApp());
}

/// Root widget configuring state providers and responsive application shell.
class TransliteratorApp extends StatelessWidget {
  const TransliteratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<TransliteratorBloc>(create: (_) => TransliteratorBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Scriptly - Polyglot Transliterator',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const TransliteratorPage(),
          );
        },
      ),
    );
  }
}
