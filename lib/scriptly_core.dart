/// Scriptly Core (Pure Dart - No Flutter / dart:ui dependency)
///
/// Contains all transliteration engines, ScriptDetector, PhoneticMatcher,
/// CustomDictionary, PII Shield, Identity Hasher, Stream Transformers, and Unicode utilities.
library;

export 'src/core/conversion_options.dart';
export 'src/core/conversion_request.dart';
export 'src/core/conversion_result.dart';
export 'src/core/custom_dictionary.dart';
export 'src/core/engine_registry.dart';
export 'src/core/errors.dart';
export 'src/core/frequency_trie.dart';
export 'src/core/language_pack_manager.dart';
export 'src/core/language_script.dart';
export 'src/core/phonetic_matcher.dart';
export 'src/core/script_detector.dart';
export 'src/core/scriptly_facade.dart';
export 'src/core/transliterator.dart';
export 'src/core/transliterator_engine.dart';
export 'src/engines/bengali/bengali_constants.dart';
export 'src/engines/bengali/bengali_engine.dart';
export 'src/engines/bengali/bengali_transliterator.dart';
export 'src/engines/custom/custom_json_engine.dart';
export 'src/engines/east_asian/japanese_engine.dart';
export 'src/engines/east_asian/korean_engine.dart';
export 'src/engines/east_asian/pinyin_engine.dart';
export 'src/engines/european/cyrillic_engine.dart';
export 'src/engines/european/greek_engine.dart';
export 'src/engines/european/south_slavic_engine.dart';
export 'src/engines/hindi/hindi_constants.dart';
export 'src/engines/hindi/hindi_engine.dart';
export 'src/engines/indic/sanskrit_engine.dart';
export 'src/engines/indic/universal_indic_engine.dart';
export 'src/engines/indic_bridge/indic_bridge_engine.dart';
export 'src/engines/middle_eastern/central_asian_engine.dart';
export 'src/engines/middle_eastern/hebrew_engine.dart';
export 'src/engines/perso_arabic/perso_arabic_constants.dart';
export 'src/engines/perso_arabic/perso_arabic_engine.dart';
export 'src/engines/phonetic/ipa_engine.dart';
export 'src/engines/southeast_asian/indochina_engine.dart';
export 'src/engines/southeast_asian/thai_engine.dart';
export 'src/engines/southeast_asian/vietnamese_engine.dart';
export 'src/engines/world/amharic_engine.dart';
export 'src/engines/world/armenian_engine.dart';
export 'src/engines/world/georgian_engine.dart';
export 'src/engines/world/ukrainian_engine.dart';
export 'src/pipeline/markdown_transliterator.dart';
export 'src/pipeline/scriptly_stream_transformer.dart';
export 'src/security/identity_hasher.dart';
export 'src/security/pii_shield.dart';
export 'src/unicode/punctuation_harmonizer.dart';
export 'src/unicode/unicode_utils.dart';
