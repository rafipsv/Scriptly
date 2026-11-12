import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme/theme_cubit.dart';

/// Top AppBar header with title, version badge, and theme mode toggle.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Row(
        children: [
          Icon(Icons.translate_rounded, color: colorScheme.primary),
          const SizedBox(width: 10),
          const Text(
            'Scriptly',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'v0.7.0',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return IconButton(
              tooltip: 'Toggle Theme',
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
