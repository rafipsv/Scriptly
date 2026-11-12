import '../engines/bengali/bengali_engine.dart';
import '../engines/east_asian/japanese_engine.dart';
import '../engines/east_asian/korean_engine.dart';
import '../engines/east_asian/pinyin_engine.dart';
import '../engines/european/cyrillic_engine.dart';
import '../engines/european/greek_engine.dart';
import '../engines/hindi/hindi_engine.dart';
import '../engines/indic/sanskrit_engine.dart';
import '../engines/indic/universal_indic_engine.dart';
import '../engines/indic_bridge/indic_bridge_engine.dart';
import '../engines/middle_eastern/central_asian_engine.dart';
import '../engines/middle_eastern/hebrew_engine.dart';
import '../engines/perso_arabic/perso_arabic_engine.dart';
import '../engines/phonetic/ipa_engine.dart';
import '../engines/southeast_asian/indochina_engine.dart';
import '../engines/southeast_asian/thai_engine.dart';
import '../engines/southeast_asian/vietnamese_engine.dart';
import '../engines/world/amharic_engine.dart';
import '../engines/world/armenian_engine.dart';
import '../engines/world/georgian_engine.dart';
import '../engines/world/ukrainian_engine.dart';
import '../engines/european/south_slavic_engine.dart';
import 'language_script.dart';
import 'transliterator_engine.dart';

/// Internal descriptor for engines initialized on-demand.
class _LazyEngineEntry {
  final String id;
  final TransliteratorEngine Function() factory;
  final bool Function(LanguageScript from, LanguageScript to) supportsChecker;
  TransliteratorEngine? instance;

  _LazyEngineEntry({
    required this.id,
    required this.factory,
    required this.supportsChecker,
  });

  TransliteratorEngine getOrCreate() => instance ??= factory();
}

/// Registry holding registered transliteration engines with eager and lazy loading support.
class EngineRegistry {
  final Map<String, TransliteratorEngine> _engines = {};
  final List<_LazyEngineEntry> _lazyEngines = [];

  /// Creates an empty [EngineRegistry].
  EngineRegistry();

  /// Creates an [EngineRegistry] pre-populated with standard default engines:
  /// - Bengali Engine
  /// - Hindi Devanagari Engine
  /// - Universal Indic Engine (Gujarati, Punjabi, Tamil, Telugu, Malayalam, Kannada, Odia, Sinhala)
  /// - Indic Bridge Engine (Brahmic cross-script slot alignment)
  /// - Perso-Arabic Engine (Arabic, Urdu, Persian)
  /// - Hebrew Engine
  /// - Japanese Engine (Hiragana/Katakana)
  /// - Korean Engine (Hangul)
  /// - Chinese Pinyin Engine
  /// - Cyrillic Engine (Russian)
  /// - Ukrainian Cyrillic Engine
  /// - Greek Engine
  /// - Vietnamese Engine (Telex)
  /// - Thai Engine (RTGS)
  /// - Georgian Engine (Mkhedruli)
  /// - Armenian Engine
  factory EngineRegistry.withDefaults() {
    final registry = EngineRegistry();
    // Specialized high-priority engines
    registry.register(SanskritIndicExtensionEngine());
    registry.register(SouthSlavicEngine());
    registry.register(IndochinaEngine());
    registry.register(CentralAsianEngine());
    registry.register(AmharicEngine());
    registry.register(IpaEngine());
    registry.register(UkrainianEngine());
    registry.register(GreekEngine());
    registry.register(VietnameseEngine());
    registry.register(ThaiEngine());
    registry.register(GeorgianEngine());
    registry.register(ArmenianEngine());

    // Indic, Perso-Arabic & East Asian
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
    return registry;
  }

  /// Registers an engine with the registry.
  void register(TransliteratorEngine engine) {
    _engines[engine.id] = engine;
  }

  /// Registers an engine to be lazily initialized upon the first conversion matching [supportsChecker].
  void registerLazy(
    String id,
    TransliteratorEngine Function() factory,
    bool Function(LanguageScript from, LanguageScript to) supportsChecker,
  ) {
    _lazyEngines.add(_LazyEngineEntry(
      id: id,
      factory: factory,
      supportsChecker: supportsChecker,
    ));
  }

  /// Unregisters an engine by its [engineId].
  void unregister(String engineId) {
    _engines.remove(engineId);
    _lazyEngines.removeWhere((e) => e.id == engineId);
  }

  /// Finds an engine that supports conversion from [from] to [to].
  TransliteratorEngine? findEngine(LanguageScript from, LanguageScript to) {
    // 1. Check already materialized engines first
    for (final engine in _engines.values) {
      if (engine.supports(from, to)) {
        return engine;
      }
    }
    // 2. Check pending lazy engines in registered priority order
    for (final entry in _lazyEngines) {
      if (entry.supportsChecker(from, to)) {
        final engine = entry.getOrCreate();
        _engines[engine.id] = engine;
        return engine;
      }
    }
    return null;
  }

  /// All currently registered engines (materializes any pending lazy engines).
  List<TransliteratorEngine> get registeredEngines {
    for (final entry in _lazyEngines) {
      if (!_engines.containsKey(entry.id)) {
        final engine = entry.getOrCreate();
        _engines[engine.id] = engine;
      }
    }
    return List.unmodifiable(_engines.values);
  }
}
