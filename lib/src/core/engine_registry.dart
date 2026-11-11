import '../engines/bengali/bengali_engine.dart';
import '../engines/east_asian/japanese_engine.dart';
import '../engines/east_asian/korean_engine.dart';
import '../engines/east_asian/pinyin_engine.dart';
import '../engines/european/cyrillic_engine.dart';
import '../engines/european/greek_engine.dart';
import '../engines/hindi/hindi_engine.dart';
import '../engines/indic/universal_indic_engine.dart';
import '../engines/indic_bridge/indic_bridge_engine.dart';
import '../engines/middle_eastern/hebrew_engine.dart';
import '../engines/perso_arabic/perso_arabic_engine.dart';
import 'language_script.dart';
import 'transliterator_engine.dart';

/// Registry holding registered transliteration engines.
class EngineRegistry {
  final Map<String, TransliteratorEngine> _engines = {};

  /// Creates an empty [EngineRegistry].
  EngineRegistry();

  /// Creates an [EngineRegistry] pre-populated with standard default engines:
  /// - Bengali Engine
  /// - Hindi Devanagari Engine
  /// - Universal Indic Engine (Gujarati, Punjabi, Tamil, Telugu, Malayalam)
  /// - Indic Bridge Engine (Devanagari ↔ Bengali direct)
  /// - Perso-Arabic Engine (Arabic, Urdu, Persian)
  /// - Hebrew Engine
  /// - Japanese Engine (Hiragana/Katakana)
  /// - Korean Engine (Hangul)
  /// - Chinese Pinyin Engine
  /// - Cyrillic Engine (Russian)
  /// - Greek Engine
  factory EngineRegistry.withDefaults() {
    final registry = EngineRegistry();
    registry.register(BengaliEngine());
    registry.register(HindiEngine());
    registry.register(UniversalIndicEngine());
    registry.register(IndicBridgeEngine());
    registry.register(PersoArabicEngine());
    registry.register(HebrewEngine());
    registry.register(JapaneseEngine());
    registry.register(KoreanEngine());
    registry.register(PinyinEngine());
    registry.register(CyrillicEngine());
    registry.register(GreekEngine());
    return registry;
  }

  /// Registers an engine with the registry.
  void register(TransliteratorEngine engine) {
    _engines[engine.id] = engine;
  }

  /// Unregisters an engine by its [engineId].
  void unregister(String engineId) {
    _engines.remove(engineId);
  }

  /// Finds an engine that supports conversion from [from] to [to].
  TransliteratorEngine? findEngine(LanguageScript from, LanguageScript to) {
    for (final engine in _engines.values) {
      if (engine.supports(from, to)) {
        return engine;
      }
    }
    return null;
  }

  /// All currently registered engines.
  List<TransliteratorEngine> get registeredEngines => List.unmodifiable(_engines.values);
}
