import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_state.dart';
import '../widgets/app_header.dart';
import '../widgets/language_selector_bar.dart';
import '../widgets/quick_samples_bar.dart';
import '../widgets/settings_footer.dart';
import '../widgets/source_card.dart';
import '../widgets/target_card.dart';

/// Main responsive view for the Transliterator application.
class TransliteratorPage extends StatefulWidget {
  const TransliteratorPage({super.key});

  @override
  State<TransliteratorPage> createState() => _TransliteratorPageState();
}

class _TransliteratorPageState extends State<TransliteratorPage> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: context.read<TransliteratorBloc>().state.sourceText,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransliteratorBloc, TransliteratorState>(
      listenWhen: (prev, curr) => prev.sourceText != curr.sourceText,
      listener: (context, state) {
        if (_inputController.text != state.sourceText) {
          _inputController.text = state.sourceText;
        }
      },
      child: Scaffold(
        appBar: const AppHeader(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 840;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LanguageSelectorBar(),
                      const SizedBox(height: 16),
                      QuickSamplesBar(
                        onSampleSelected: (sample) =>
                            _inputController.text = sample,
                      ),
                      const SizedBox(height: 16),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SourceCard(controller: _inputController),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: TargetCard()),
                          ],
                        )
                      else ...[
                        SourceCard(controller: _inputController),
                        const SizedBox(height: 16),
                        const TargetCard(),
                      ],
                      const SizedBox(height: 20),
                      const SettingsFooter(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
