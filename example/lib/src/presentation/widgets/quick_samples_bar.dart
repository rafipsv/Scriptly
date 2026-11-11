import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';

/// Horizontal list of clickable sample phrase chips.
class QuickSamplesBar extends StatelessWidget {
  final ValueChanged<String>? onSampleSelected;

  const QuickSamplesBar({super.key, this.onSampleSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'Try sample:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          for (final phrase in AppConstants.samplePhrases) ...[
            ActionChip(
              label: Text(phrase, style: const TextStyle(fontSize: 12)),
              onPressed: () {
                onSampleSelected?.call(phrase);
                context.read<TransliteratorBloc>().add(
                  TransliteratorTextChanged(phrase),
                );
              },
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}
