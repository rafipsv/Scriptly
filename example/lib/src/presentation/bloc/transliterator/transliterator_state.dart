import 'package:equatable/equatable.dart';
import 'package:scriptly/scriptly.dart';

/// Represents the UI state of the Transliterator view.
class TransliteratorState extends Equatable {
  final String sourceText;
  final String outputText;
  final LanguageScript sourceLang;
  final LanguageScript targetLang;
  final bool convertDigits;
  final bool shieldPii;
  final bool harmonizePunctuation;
  final bool markdownMode;
  final String activeScheme;

  const TransliteratorState({
    required this.sourceText,
    required this.outputText,
    required this.sourceLang,
    required this.targetLang,
    this.convertDigits = false,
    this.shieldPii = false,
    this.harmonizePunctuation = false,
    this.markdownMode = false,
    this.activeScheme = '',
  });

  /// Initial state on application startup.
  factory TransliteratorState.initial() => const TransliteratorState(
    sourceText: 'Ami Banglay gaan gai',
    outputText: '',
    sourceLang: LanguageScript.latin,
    targetLang: LanguageScript.bengali,
    convertDigits: false,
    shieldPii: false,
    harmonizePunctuation: false,
    markdownMode: false,
    activeScheme: '',
  );

  TransliteratorState copyWith({
    String? sourceText,
    String? outputText,
    LanguageScript? sourceLang,
    LanguageScript? targetLang,
    bool? convertDigits,
    bool? shieldPii,
    bool? harmonizePunctuation,
    bool? markdownMode,
    String? activeScheme,
  }) {
    return TransliteratorState(
      sourceText: sourceText ?? this.sourceText,
      outputText: outputText ?? this.outputText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      convertDigits: convertDigits ?? this.convertDigits,
      shieldPii: shieldPii ?? this.shieldPii,
      harmonizePunctuation: harmonizePunctuation ?? this.harmonizePunctuation,
      markdownMode: markdownMode ?? this.markdownMode,
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
    shieldPii,
    harmonizePunctuation,
    markdownMode,
    activeScheme,
  ];
}
