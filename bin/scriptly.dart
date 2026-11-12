import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:scriptly/scriptly_core.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('convert')
    ..addCommand('detect')
    ..addCommand('file')
    ..addCommand('i18n')
    ..addCommand('markdown')
    ..addCommand('list');

  // Configure 'convert' command
  parser.commands['convert']!
    ..addOption(
      'to',
      abbr: 't',
      mandatory: true,
      help: 'Target script code (e.g. bn-Beng, hi-Deva, ar-Arab)',
    )
    ..addOption(
      'from',
      abbr: 'f',
      help: 'Source script code (auto-detected if omitted)',
    )
    ..addFlag(
      'digits',
      abbr: 'd',
      help: 'Convert digits to target script',
      defaultsTo: false,
    );

  // Configure 'detect' command
  parser.commands['detect']!;

  // Configure 'file' command
  parser.commands['file']!
    ..addOption('input', abbr: 'i', mandatory: true, help: 'Input file path')
    ..addOption('output', abbr: 'o', mandatory: true, help: 'Output file path')
    ..addOption('to', abbr: 't', mandatory: true, help: 'Target script code')
    ..addOption(
      'from',
      abbr: 'f',
      help: 'Source script code (auto-detected if omitted)',
    )
    ..addFlag(
      'digits',
      abbr: 'd',
      help: 'Convert digits to target script',
      defaultsTo: false,
    );

  // Configure 'i18n' command
  parser.commands['i18n']!
    ..addOption(
      'input',
      abbr: 'i',
      mandatory: true,
      help: 'Input ARB or JSON file path',
    )
    ..addOption(
      'output',
      abbr: 'o',
      mandatory: true,
      help: 'Output ARB or JSON file path',
    )
    ..addOption('to', abbr: 't', mandatory: true, help: 'Target script code')
    ..addOption(
      'from',
      abbr: 'f',
      help: 'Source script code (defaults to en-Latn)',
    );

  // Configure 'markdown' command
  parser.commands['markdown']!
    ..addOption(
      'input',
      abbr: 'i',
      mandatory: true,
      help: 'Input Markdown file path',
    )
    ..addOption(
      'output',
      abbr: 'o',
      mandatory: true,
      help: 'Output Markdown file path',
    )
    ..addOption('to', abbr: 't', mandatory: true, help: 'Target script code')
    ..addOption(
      'from',
      abbr: 'f',
      help: 'Source script code (defaults to en-Latn)',
    );

  if (arguments.isEmpty) {
    _printUsage(parser);
    return;
  }

  try {
    final results = parser.parse(arguments);
    final command = results.command;

    if (command == null) {
      _printUsage(parser);
      return;
    }

    final transliterator = Transliterator();

    switch (command.name) {
      case 'convert':
        _handleConvert(command, transliterator);
        break;
      case 'detect':
        _handleDetect(command);
        break;
      case 'file':
        _handleFile(command, transliterator);
        break;
      case 'i18n':
        _handleI18n(command, transliterator);
        break;
      case 'markdown':
        _handleMarkdown(command, transliterator);
        break;
      case 'list':
        _handleList();
        break;
      default:
        _printUsage(parser);
    }
  } catch (e) {
    stderr.writeln('Error: $e');
    exitCode = 1;
  }
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Scriptly CLI - Offline Polyglot Transliteration Tool\n');
  stdout.writeln('Usage:');
  stdout.writeln('  scriptly convert -t <target> [-f <source>] "<text>"');
  stdout.writeln('  scriptly detect "<text>"');
  stdout.writeln('  scriptly file -i <input.txt> -o <output.txt> -t <target>');
  stdout.writeln(
    '  scriptly i18n -i <app_en.arb> -o <app_bn.arb> -t <bn-Beng>',
  );
  stdout.writeln('  scriptly markdown -i <doc.md> -o <doc_bn.md> -t <bn-Beng>');
  stdout.writeln('  scriptly list\n');
  stdout.writeln('Commands:');
  stdout.writeln(parser.usage);
}

void _handleConvert(ArgResults command, Transliterator transliterator) {
  final text = command.rest.join(' ').trim();
  if (text.isEmpty) {
    stderr.writeln('Error: No text provided to convert.');
    exitCode = 1;
    return;
  }

  final targetCode = command['to'] as String;
  final targetScript = LanguageScript.fromCode(targetCode);
  final digits = command['digits'] as bool;
  final options = ConversionOptions(
    digitPolicy: digits
        ? DigitPolicy.convertToTarget
        : DigitPolicy.preserveSource,
  );

  final fromCode = command['from'] as String?;
  final result = fromCode != null
      ? transliterator.convert(
          text,
          from: LanguageScript.fromCode(fromCode),
          to: targetScript,
          options: options,
        )
      : transliterator.autoConvert(text, to: targetScript, options: options);

  stdout.writeln(result.text);
}

void _handleDetect(ArgResults command) {
  final text = command.rest.join(' ').trim();
  if (text.isEmpty) {
    stderr.writeln('Error: No text provided to detect.');
    exitCode = 1;
    return;
  }

  final result = ScriptDetector.detect(text);
  stdout.writeln(
    'Detected Script: ${result.script.name} (${result.script.code})',
  );
  stdout.writeln(
    'Confidence:      ${(result.confidence * 100).toStringAsFixed(1)}%',
  );
  stdout.writeln('Scored Runes:    ${result.totalScoredCharacters}');
}

void _handleFile(ArgResults command, Transliterator transliterator) {
  final inputPath = command['input'] as String;
  final outputPath = command['output'] as String;
  final targetCode = command['to'] as String;
  final targetScript = LanguageScript.fromCode(targetCode);
  final digits = command['digits'] as bool;
  final options = ConversionOptions(
    digitPolicy: digits
        ? DigitPolicy.convertToTarget
        : DigitPolicy.preserveSource,
  );

  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    stderr.writeln('Error: Input file does not exist: $inputPath');
    exitCode = 1;
    return;
  }

  final content = inputFile.readAsStringSync();
  final fromCode = command['from'] as String?;
  final result = fromCode != null
      ? transliterator.convert(
          content,
          from: LanguageScript.fromCode(fromCode),
          to: targetScript,
          options: options,
        )
      : transliterator.autoConvert(content, to: targetScript, options: options);

  File(outputPath).writeAsStringSync(result.text);
  stdout.writeln(
    'Successfully converted $inputPath -> $outputPath (${result.scheme})',
  );
}

void _handleI18n(ArgResults command, Transliterator transliterator) {
  final inputPath = command['input'] as String;
  final outputPath = command['output'] as String;
  final targetCode = command['to'] as String;
  final fromCode = command['from'] as String? ?? 'en-Latn';

  final fromScript = LanguageScript.fromCode(fromCode);
  final targetScript = LanguageScript.fromCode(targetCode);

  final file = File(inputPath);
  if (!file.existsSync()) {
    stderr.writeln('Error: i18n input file does not exist: $inputPath');
    exitCode = 1;
    return;
  }

  final jsonContent = jsonDecode(file.readAsStringSync());
  if (jsonContent is! Map<String, dynamic>) {
    stderr.writeln('Error: Expected JSON object map in $inputPath');
    exitCode = 1;
    return;
  }

  final placeholderRegex = RegExp(r'\{[a-zA-Z0-9_]+\}');
  final translatedMap = <String, dynamic>{};

  for (final entry in jsonContent.entries) {
    // If it's ARB metadata (starts with '@'), retain unchanged
    if (entry.key.startsWith('@')) {
      translatedMap[entry.key] = entry.value;
      continue;
    }

    if (entry.value is String) {
      final original = entry.value as String;
      final tokens = <String, String>{};
      var counter = 0;

      final shielded = original.replaceAllMapped(placeholderRegex, (m) {
        final token = '[[__PH_${counter++}__]]';
        tokens[token] = m[0]!;
        return token;
      });

      final converted = transliterator.convert(
        shielded,
        from: fromScript,
        to: targetScript,
      );

      var finalText = converted.text;
      for (final ph in tokens.entries) {
        finalText = finalText.replaceAll(ph.key, ph.value);
      }

      translatedMap[entry.key] = finalText;
    } else {
      translatedMap[entry.key] = entry.value;
    }
  }

  final encoder = const JsonEncoder.withIndent('  ');
  File(outputPath).writeAsStringSync(encoder.convert(translatedMap));
  stdout.writeln('Successfully generated i18n translation: $outputPath');
}

void _handleMarkdown(ArgResults command, Transliterator transliterator) {
  final inputPath = command['input'] as String;
  final outputPath = command['output'] as String;
  final targetCode = command['to'] as String;
  final fromCode = command['from'] as String? ?? 'en-Latn';

  final fromScript = LanguageScript.fromCode(fromCode);
  final targetScript = LanguageScript.fromCode(targetCode);

  final file = File(inputPath);
  if (!file.existsSync()) {
    stderr.writeln('Error: Markdown input file does not exist: $inputPath');
    exitCode = 1;
    return;
  }

  final content = file.readAsStringSync();
  final mdTransliterator = MarkdownTransliterator(
    transliterator: transliterator,
  );
  final result = mdTransliterator.convert(
    content,
    from: fromScript,
    to: targetScript,
  );

  File(outputPath).writeAsStringSync(result);
  stdout.writeln('Successfully transliterated markdown document: $outputPath');
}

void _handleList() {
  stdout.writeln(
    'Supported Scripts in Scriptly (${LanguageScript.values.length} total):\n',
  );
  for (final s in LanguageScript.values) {
    stdout.writeln('  • ${s.code.padRight(10)} : ${s.name} [${s.category}]');
  }
}
