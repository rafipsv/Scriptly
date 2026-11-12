import 'dart:async';

import '../core/conversion_options.dart';
import '../core/language_script.dart';
import '../core/transliterator.dart';

/// Stream transformer that transliterates incoming chunks of text line-by-line
/// or chunk-by-chunk with zero memory bloat.
class ScriptlyStreamTransformer extends StreamTransformerBase<String, String> {
  final LanguageScript from;
  final LanguageScript to;
  final ConversionOptions options;
  final Transliterator _transliterator;

  ScriptlyStreamTransformer({
    required this.from,
    required this.to,
    this.options = const ConversionOptions(),
    Transliterator? transliterator,
  }) : _transliterator = transliterator ?? Transliterator();

  @override
  Stream<String> bind(Stream<String> stream) {
    return Stream<String>.eventTransformed(stream, (sink) {
      return _ScriptlyEventSink(sink, from, to, options, _transliterator);
    });
  }
}

class _ScriptlyEventSink implements EventSink<String> {
  final EventSink<String> _outputSink;
  final LanguageScript _from;
  final LanguageScript _to;
  final ConversionOptions _options;
  final Transliterator _transliterator;

  _ScriptlyEventSink(
    this._outputSink,
    this._from,
    this._to,
    this._options,
    this._transliterator,
  );

  @override
  void add(String event) {
    // Process line-by-line or chunk directly
    final converted = _transliterator.convert(
      event,
      from: _from,
      to: _to,
      options: _options,
    );
    _outputSink.add(converted.text);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _outputSink.addError(error, stackTrace);
  }

  @override
  void close() {
    _outputSink.close();
  }
}
