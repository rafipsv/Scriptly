import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

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
  }) {
    final curText = text ?? state.sourceText;
    final curFrom = from ?? state.sourceLang;
    final curTo = to ?? state.targetLang;
    final curDigits = digits ?? state.convertDigits;
    final res = _compute(curText, curFrom, curTo, curDigits);

    emit(
      state.copyWith(
        sourceText: curText,
        sourceLang: curFrom,
        targetLang: curTo,
        convertDigits: curDigits,
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
      return _transliterator.convert(text, from: from, to: to, options: opt);
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
