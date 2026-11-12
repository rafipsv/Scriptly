import 'dart:io';

import 'package:args/args.dart';
import 'package:scriptly/scriptly_core.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('convert')
    ..addCommand('detect')
    ..addCommand('file')
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

void _handleList() {
  stdout.writeln(
    'Supported Scripts in Scriptly (${LanguageScript.values.length} total):\n',
  );
  for (final s in LanguageScript.values) {
    stdout.writeln('  • ${s.code.padRight(10)} : ${s.name} [${s.category}]');
  }
}
