import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';

/// Card managing the source text input area.
class SourceCard extends StatelessWidget {
  final TextEditingController controller;

  const SourceCard({super.key, required this.controller});

  void _copy(BuildContext context, String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Source text copied to clipboard!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SOURCE TEXT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: colorScheme.primary,
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox(height: 32);
                    return IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Clear',
                      onPressed: () {
                        controller.clear();
                        context.read<TransliteratorBloc>().add(
                          const TransliteratorTextCleared(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              minLines: 6,
              maxLines: 12,
              style: const TextStyle(fontSize: 18, height: 1.5),
              decoration: const InputDecoration(
                hintText: 'Enter text here (e.g. Ami Banglay gaan gai)...',
                border: InputBorder.none,
              ),
              onChanged: (text) => context.read<TransliteratorBloc>().add(
                TransliteratorTextChanged(text),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => Text(
                    '${value.text.length} characters',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Input',
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  onPressed: () => _copy(context, controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
