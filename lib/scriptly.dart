/// Scriptly
///
/// An extensible, offline-first multi-language transliteration engine for Flutter and Dart.
/// Converts text between scripts across Indic, East Asian, Middle Eastern, and European languages.
library;

export 'src/core/conversion_options.dart';
export 'src/core/conversion_request.dart';
export 'src/core/conversion_result.dart';
export 'src/core/engine_registry.dart';
export 'src/core/errors.dart';
export 'src/core/language_script.dart';
export 'src/core/transliterator.dart';
export 'src/core/transliterator_engine.dart';
export 'src/engines/bengali/bengali_constants.dart';
export 'src/engines/bengali/bengali_engine.dart';
export 'src/engines/bengali/bengali_transliterator.dart';
export 'src/engines/east_asian/japanese_engine.dart';
export 'src/engines/east_asian/korean_engine.dart';
export 'src/engines/east_asian/pinyin_engine.dart';
export 'src/engines/european/cyrillic_engine.dart';
export 'src/engines/european/greek_engine.dart';
export 'src/engines/hindi/hindi_constants.dart';
export 'src/engines/hindi/hindi_engine.dart';
export 'src/engines/indic/universal_indic_engine.dart';
export 'src/engines/indic_bridge/indic_bridge_engine.dart';
export 'src/engines/middle_eastern/hebrew_engine.dart';
export 'src/engines/perso_arabic/perso_arabic_constants.dart';
export 'src/engines/perso_arabic/perso_arabic_engine.dart';
export 'src/engines/southeast_asian/thai_engine.dart';
export 'src/engines/southeast_asian/vietnamese_engine.dart';
export 'src/engines/world/armenian_engine.dart';
export 'src/engines/world/georgian_engine.dart';
export 'src/engines/world/ukrainian_engine.dart';
export 'src/unicode/unicode_utils.dart';
export 'src/widgets/transliteration_controller.dart';
