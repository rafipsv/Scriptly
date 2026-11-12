import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scriptly/scriptly.dart';

import 'src/core/theme/app_theme.dart';
import 'src/presentation/bloc/theme/theme_cubit.dart';
import 'src/presentation/bloc/transliterator/transliterator_bloc.dart';
import 'src/presentation/pages/transliterator_page.dart';

void main() {
  // ===========================================================================
  // 1. Programmatic Transliteration Usage (Pure Dart / Offline)
  // ===========================================================================
  final transliterator = Transliterator();

  // Example A: Phonetic Latin (Banglish) to Bengali
  final bengali = transliterator.convert(
    'ami banglay gan gai',
    from: LanguageScript.latin,
    to: LanguageScript.bengali,
  );
  debugPrint('Bengali: ${bengali.text}'); // Output: আমি বাংলায় গান গাই

  // Example B: Phonetic Latin (Hinglish) to Hindi (Devanagari)
  final hindi = transliterator.convert(
    'namaste aap kaise ho',
    from: LanguageScript.latin,
    to: LanguageScript.hindi,
  );
  debugPrint('Hindi: ${hindi.text}'); // Output: नमस्ते आप कैसे हो

  // Example C: Direct Brahmic Bridge (Devanagari -> Bengali without Latin)
  final bengaliFromHindi = transliterator.convert(
    'नमस्ते भारत',
    from: LanguageScript.hindi,
    to: LanguageScript.bengali,
  );
  debugPrint('Brahmic Bridge: ${bengaliFromHindi.text}'); // Output: নমস্তে ভারত

  // Example D: East Asian (Japanese Romaji -> Hiragana/Katakana)
  final japanese = transliterator.convert(
    'arigatou konnichiwa',
    from: LanguageScript.latin,
    to: LanguageScript.japanese,
  );
  debugPrint('Japanese: ${japanese.text}'); // Output: ありがとう こんにちわ

  // Example E: Perso-Arabic (Latin -> Arabic)
  final arabic = transliterator.convert(
    'marhaban bikum',
    from: LanguageScript.latin,
    to: LanguageScript.arabic,
  );
  debugPrint('Arabic: ${arabic.text}'); // Output: مرحبا بكم

  // Example F: Converting ASCII digits to native script digits
  final withNativeDigits = transliterator.convert(
    'amar 500 taka ache',
    from: LanguageScript.latin,
    to: LanguageScript.bengali,
    options: const ConversionOptions(
      digitPolicy: DigitPolicy.convertToTarget,
    ),
  );
  debugPrint('Native Digits: ${withNativeDigits.text}'); // Output: আমার ৫০০ টাকা আছে

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

// =============================================================================
// 2. Real-Time Flutter TextField Widget Example
// =============================================================================
/// Copy-pasteable example showing how to integrate [TransliterationTextEditingController]
/// with a standard Flutter [TextField] for live, real-time phonetic typing.
class SimpleTransliterationExample extends StatefulWidget {
  const SimpleTransliterationExample({super.key});

  @override
  State<SimpleTransliterationExample> createState() =>
      _SimpleTransliterationExampleState();
}

class _SimpleTransliterationExampleState
    extends State<SimpleTransliterationExample> {
  // Step 1: Declare the controller
  late final TransliterationTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Step 2: Initialize with desired source and target scripts
    _controller = TransliterationTextEditingController(
      from: LanguageScript.latin,
      to: LanguageScript.bengali,
      text: 'ami banglay gaan gai',
    );
  }

  @override
  void dispose() {
    // Step 3: Dispose the controller when done
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Transliteration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Standard Flutter TextField using TransliterationTextEditingController
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Type phonetically in Latin / Banglish...',
                hintText: 'e.g. ami bhalo achi',
                border: OutlineInputBorder(),
                helperText: 'Converts in real-time to Bengali script',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
