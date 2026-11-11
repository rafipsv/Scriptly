import 'package:equatable/equatable.dart';
import 'package:scriptly/scriptly.dart';

/// Represents the UI state of the Transliterator view.
class TransliteratorState extends Equatable {
  final String sourceText;
  final String outputText;
  final LanguageScript sourceLang;
  final LanguageScript targetLang;
  final bool convertDigits;
  final String activeScheme;

  const TransliteratorState({
    required this.sourceText,
    required this.outputText,
    required this.sourceLang,
    required this.targetLang,
    this.convertDigits = false,
    this.activeScheme = '',
  });

  /// Initial state on application startup.
  factory TransliteratorState.initial() => const TransliteratorState(
    sourceText: 'Ami Banglay gaan gai',
    outputText: '',
    sourceLang: LanguageScript.latin,
    targetLang: LanguageScript.bengali,
    convertDigits: false,
    activeScheme: '',
  );

  TransliteratorState copyWith({
    String? sourceText,
    String? outputText,
    LanguageScript? sourceLang,
    LanguageScript? targetLang,
    bool? convertDigits,
    String? activeScheme,
  }) {
    return TransliteratorState(
      sourceText: sourceText ?? this.sourceText,
      outputText: outputText ?? this.outputText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      convertDigits: convertDigits ?? this.convertDigits,
      activeScheme: activeScheme ?? this.activeScheme,
    );
  }

  @override
  List<Object?> get props => [
    sourceText,
    outputText,
    sourceLang,
    targetLang,
    convertDigits,
    activeScheme,
  ];
}
