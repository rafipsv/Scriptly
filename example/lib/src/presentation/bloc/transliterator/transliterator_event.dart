import 'package:equatable/equatable.dart';
import 'package:scriptly/scriptly.dart';

/// Base event class for transliterator operations.
abstract class TransliteratorEvent extends Equatable {
  const TransliteratorEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the input source text changes.
class TransliteratorTextChanged extends TransliteratorEvent {
  final String text;

  const TransliteratorTextChanged(this.text);

  @override
  List<Object?> get props => [text];
}

/// Triggered when the source language/script is selected.
class TransliteratorSourceChanged extends TransliteratorEvent {
  final LanguageScript script;

  const TransliteratorSourceChanged(this.script);

  @override
  List<Object?> get props => [script];
}

/// Triggered when the target language/script is selected.
class TransliteratorTargetChanged extends TransliteratorEvent {
  final LanguageScript script;

  const TransliteratorTargetChanged(this.script);

  @override
  List<Object?> get props => [script];
}

/// Triggered when the user swaps source and target scripts.
class TransliteratorLanguagesSwapped extends TransliteratorEvent {
  const TransliteratorLanguagesSwapped();
}

/// Triggered when the user toggles digit conversion policy.
class TransliteratorDigitsToggled extends TransliteratorEvent {
  final bool convertDigits;

  const TransliteratorDigitsToggled(this.convertDigits);

  @override
  List<Object?> get props => [convertDigits];
}

/// Triggered to clear the source text.
class TransliteratorTextCleared extends TransliteratorEvent {
  const TransliteratorTextCleared();
}
