import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';
import '../bloc/transliterator/transliterator_state.dart';

/// Bottom settings card providing client-side offline info and digit policy controls.
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.offline_bolt_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '100% Client-Side & Offline (No APIs, No Tracking)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            BlocBuilder<TransliteratorBloc, TransliteratorState>(
              buildWhen: (prev, curr) =>
                  prev.convertDigits != curr.convertDigits,
              builder: (context, state) {
                return Row(
                  children: [
                    Text(
                      'Convert Digits:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: state.convertDigits,
                      onChanged: (val) => context
                          .read<TransliteratorBloc>()
                          .add(TransliteratorDigitsToggled(val)),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
