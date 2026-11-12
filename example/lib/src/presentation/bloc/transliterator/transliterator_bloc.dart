import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scriptly/scriptly.dart';

import 'transliterator_event.dart';
import 'transliterator_state.dart';

/// Business Logic Component governing transliteration workflows.
class TransliteratorBloc
    extends Bloc<TransliteratorEvent, TransliteratorState> {
  final Transliterator _transliterator;

  TransliteratorBloc({Transliterator? transliterator})
    : _transliterator = transliterator ?? Transliterator(),
      super(TransliteratorState.initial()) {
    on<TransliteratorTextChanged>((e, emit) => _update(emit, text: e.text));
    on<TransliteratorSourceChanged>((e, emit) => _update(emit, from: e.script));
    on<TransliteratorTargetChanged>((e, emit) => _update(emit, to: e.script));
    on<TransliteratorDigitsToggled>(
      (e, emit) => _update(emit, digits: e.convertDigits),
    );
    on<TransliteratorPiiToggled>(
      (e, emit) => _update(emit, shieldPii: e.shieldPii),
    );
    on<TransliteratorPunctuationToggled>(
      (e, emit) => _update(emit, harmonizePunctuation: e.harmonizePunctuation),
    );
    on<TransliteratorMarkdownToggled>(
      (e, emit) => _update(emit, markdownMode: e.markdownMode),
    );
    on<TransliteratorTextCleared>(
      (e, emit) => emit(
        state.copyWith(sourceText: '', outputText: '', activeScheme: ''),
      ),
    );
    on<TransliteratorLanguagesSwapped>((e, emit) {
      final s = state.targetLang, t = state.sourceLang;
      final text = state.outputText.isNotEmpty
          ? state.outputText
          : state.sourceText;
      _update(emit, from: s, to: t, text: text);
    });

    add(TransliteratorTextChanged(state.sourceText));
  }

  void _update(
    Emitter<TransliteratorState> emit, {
    String? text,
    LanguageScript? from,
    LanguageScript? to,
    bool? digits,
    bool? shieldPii,
    bool? harmonizePunctuation,
    bool? markdownMode,
  }) {
    final curText = text ?? state.sourceText;
    final curFrom = from ?? state.sourceLang;
    final curTo = to ?? state.targetLang;
    final curDigits = digits ?? state.convertDigits;
    final curPii = shieldPii ?? state.shieldPii;
    final curPunct = harmonizePunctuation ?? state.harmonizePunctuation;
    final curMarkdown = markdownMode ?? state.markdownMode;

    final res = _compute(
      curText,
      curFrom,
      curTo,
      curDigits,
      curPii,
      curPunct,
      curMarkdown,
    );

    emit(
      state.copyWith(
        sourceText: curText,
        sourceLang: curFrom,
        targetLang: curTo,
        convertDigits: curDigits,
        shieldPii: curPii,
        harmonizePunctuation: curPunct,
        markdownMode: curMarkdown,
        outputText: res.text,
        activeScheme: res.scheme,
      ),
    );
  }

  ConversionResult _compute(
    String text,
    LanguageScript from,
    LanguageScript to,
    bool digits,
    bool shieldPii,
    bool harmonizePunctuation,
    bool markdownMode,
  ) {
    if (text.isEmpty) {
      return ConversionResult(
        text: '',
        sourceText: '',
        from: from,
        to: to,
        scheme: '',
      );
    }
    try {
      final opt = ConversionOptions(
        digitPolicy: digits
            ? DigitPolicy.convertToTarget
            : DigitPolicy.preserveSource,
      );

      var inputText = text;
      Map<String, String>? piiTokens;

      // 1. PII Shielding if enabled
      if (shieldPii) {
        final piiResult = Scriptly.shieldPii(inputText);
        inputText = piiResult.text;
        piiTokens = piiResult.tokens;
      }

      String convertedText;
      String scheme;

      // 2. Markdown vs Standard Transliteration
      if (markdownMode) {
        convertedText = Scriptly.convertMarkdown(
          inputText,
          from: from,
          to: to,
          options: opt,
        );
        scheme = 'markdown-pipeline';
      } else {
        final res = _transliterator.convert(
          inputText,
          from: from,
          to: to,
          options: opt,
        );
        convertedText = res.text;
        scheme = res.scheme;
      }

      // 3. Restore PII if shielded
      if (shieldPii && piiTokens != null) {
        convertedText = Scriptly.restorePii(convertedText, piiTokens);
      }

      // 4. Regional Punctuation Harmonizer if enabled
      if (harmonizePunctuation) {
        convertedText = Scriptly.harmonizePunctuation(convertedText, to);
      }

      return ConversionResult(
        text: convertedText,
        sourceText: text,
        from: from,
        to: to,
        scheme: scheme,
      );
    } catch (_) {
      return ConversionResult(
        text: text,
        sourceText: text,
        from: from,
        to: to,
        scheme: 'unsupported',
      );
    }
  }
}
