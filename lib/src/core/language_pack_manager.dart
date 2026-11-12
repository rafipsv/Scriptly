import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../engines/custom/custom_json_engine.dart';
import 'engine_registry.dart';

/// Manages serialization, compression, and runtime registration of
/// community dialect and custom script packs (`.scriptly` binary packs).
class LanguagePackManager {
  LanguagePackManager._();

  /// Magic header for .scriptly binary packs: "SPLY" (0x53, 0x50, 0x4C, 0x59)
  static const List<int> magicHeader = [0x53, 0x50, 0x4C, 0x59];

  /// Compresses a custom language JSON definition string into a `.scriptly` binary byte payload.
  static Uint8List exportPack(String jsonString) {
    // Validate JSON structure first
    jsonDecode(jsonString);

    final jsonBytes = utf8.encode(jsonString);
    final compressed = gzip.encode(jsonBytes);

    final buffer = BytesBuilder();
    buffer.add(magicHeader);
    buffer.add(compressed);

    return buffer.toBytes();
  }

  /// Exports a custom language JSON definition directly to a `.scriptly` file.
  static Future<File> exportToFile(String jsonString, String targetPath) async {
    final bytes = exportPack(jsonString);
    final file = File(targetPath);
    return file.writeAsBytes(bytes);
  }

  /// Imports and registers a `.scriptly` binary pack into [EngineRegistry].
  static CustomJsonEngine importPack(
    Uint8List packBytes, {
    EngineRegistry? registry,
  }) {
    if (packBytes.length < 4) {
      throw const FormatException('Invalid .scriptly pack: payload too short');
    }

    // Verify magic header
    for (var i = 0; i < 4; i++) {
      if (packBytes[i] != magicHeader[i]) {
        throw const FormatException(
          'Invalid .scriptly pack: unrecognized header signature',
        );
      }
    }

    final compressed = packBytes.sublist(4);
    final jsonBytes = gzip.decode(compressed);
    final jsonString = utf8.decode(jsonBytes);

    final engine = CustomJsonEngine.fromJson(jsonString);
    (registry ?? EngineRegistry.withDefaults()).register(engine);
    return engine;
  }

  /// Imports and registers a `.scriptly` file directly into [EngineRegistry].
  static Future<CustomJsonEngine> importFromFile(
    String filePath, {
    EngineRegistry? registry,
  }) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return importPack(bytes, registry: registry);
  }
}
