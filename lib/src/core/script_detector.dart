import 'language_script.dart';

/// Represents the result of an automatic script detection analysis.
class ScriptDetectionResult {
  /// The primary detected script with the highest occurrence frequency.
  final LanguageScript script;

  /// Confidence score between 0.0 and 1.0.
  final double confidence;

  /// Percentage distribution across all detected scripts in the input text.
  final Map<LanguageScript, double> distribution;

  /// Total count of classified alphabetic script characters analyzed.
  final int totalScoredCharacters;

  const ScriptDetectionResult({
    required this.script,
    required this.confidence,
    required this.distribution,
    required this.totalScoredCharacters,
  });

  /// True if the primary script accounts for at least 50% of scored text.
  bool get isReliable => confidence >= 0.5 && totalScoredCharacters > 0;

  @override
  String toString() =>
      'ScriptDetectionResult(script: ${script.code}, confidence: ${(confidence * 100).toStringAsFixed(1)}%, chars: $totalScoredCharacters)';
}

/// Fast, deterministic Unicode block analyzer for automatic script identification.
class ScriptDetector {
  const ScriptDetector._();

  /// Analyzes the given [text] and returns the detected primary [LanguageScript].
  ///
  /// Ignores whitespace, numeric digits, emojis, and common punctuation.
  static ScriptDetectionResult detect(String text) {
    if (text.isEmpty) {
      return const ScriptDetectionResult(
        script: LanguageScript.latin,
        confidence: 0.0,
        distribution: {},
        totalScoredCharacters: 0,
      );
    }

    final counts = <LanguageScript, int>{};
    var totalChars = 0;

    var hasUkrainianSpecific = false;
    var hasSerbianSpecific = false;
    var hasMacedonianSpecific = false;
    var hasBelarusianSpecific = false;
    var hasKazakhSpecific = false;
    var hasUrduSpecific = false;
    var hasKurdishSpecific = false;
    var hasPashtoSpecific = false;
    var hasVietnameseDiacritic = false;

    for (final rune in text.runes) {
      final detected = _identifyScriptRune(rune);
      if (detected != null) {
        counts[detected] = (counts[detected] ?? 0) + 1;
        totalChars++;

        // Sub-family markers
        if (rune == 0x0456 || rune == 0x0457 || rune == 0x0454 || rune == 0x0491) {
          hasUkrainianSpecific = true;
        }
        if (rune == 0x0452 || rune == 0x0458 || rune == 0x0459 || rune == 0x045A || rune == 0x045B || rune == 0x045F) {
          hasSerbianSpecific = true;
        }
        if (rune == 0x0453 || rune == 0x045C || rune == 0x0455) {
          hasMacedonianSpecific = true;
        }
        if (rune == 0x045E) {
          hasBelarusianSpecific = true;
        }
        if (rune == 0x04D8 || rune == 0x04D9 || rune == 0x0492 || rune == 0x049A || rune == 0x04E8 || rune == 0x04B0 || rune == 0x04AE) {
          hasKazakhSpecific = true;
        }
        if (rune == 0x0679 || rune == 0x0688 || rune == 0x0691 || rune == 0x06D2) {
          hasUrduSpecific = true;
        }
        if (rune == 0x06C6 || rune == 0x06CE || rune == 0x0695 || rune == 0x06B5) {
          hasKurdishSpecific = true;
        }
        if (rune == 0x069A || rune == 0x0698 || rune == 0x0685 || rune == 0x0681 || rune == 0x06BC || rune == 0x0689 || rune == 0x067C || rune == 0x0693) {
          hasPashtoSpecific = true;
        }
        if (rune >= 0x1EA0 && rune <= 0x1EF9) {
          hasVietnameseDiacritic = true;
        }
      }
    }

    if (totalChars == 0) {
      return const ScriptDetectionResult(
        script: LanguageScript.latin,
        confidence: 0.0,
        distribution: {},
        totalScoredCharacters: 0,
      );
    }

    // Refine specific sub-scripts
    if (counts.containsKey(LanguageScript.russian)) {
      if (hasUkrainianSpecific) {
        counts[LanguageScript.ukrainian] = counts.remove(LanguageScript.russian)!;
      } else if (hasSerbianSpecific) {
        counts[LanguageScript.serbian] = counts.remove(LanguageScript.russian)!;
      } else if (hasMacedonianSpecific) {
        counts[LanguageScript.macedonian] = counts.remove(LanguageScript.russian)!;
      } else if (hasBelarusianSpecific) {
        counts[LanguageScript.belarusian] = counts.remove(LanguageScript.russian)!;
      } else if (hasKazakhSpecific) {
        counts[LanguageScript.kazakh] = counts.remove(LanguageScript.russian)!;
      }
    }
    if (counts.containsKey(LanguageScript.arabic)) {
      if (hasUrduSpecific) {
        counts[LanguageScript.urdu] = counts.remove(LanguageScript.arabic)!;
      } else if (hasKurdishSpecific) {
        counts[LanguageScript.kurdish] = counts.remove(LanguageScript.arabic)!;
      } else if (hasPashtoSpecific) {
        counts[LanguageScript.pashto] = counts.remove(LanguageScript.arabic)!;
      }
    }
    if (counts.containsKey(LanguageScript.latin) && hasVietnameseDiacritic) {
      final cnt = counts.remove(LanguageScript.latin)!;
      counts[LanguageScript.vietnamese] = cnt;
    }

    // Find the highest frequency script
    var highestScript = LanguageScript.latin;
    var highestCount = 0;

    LanguageScript? prominentNonLatin;
    var maxNonLatinCount = 0;

    final distribution = <LanguageScript, double>{};
    for (final entry in counts.entries) {
      final fraction = entry.value / totalChars;
      distribution[entry.key] = fraction;
      if (entry.value > highestCount) {
        highestCount = entry.value;
        highestScript = entry.key;
      }
      if (entry.key != LanguageScript.latin && entry.value > maxNonLatinCount) {
        maxNonLatinCount = entry.value;
        prominentNonLatin = entry.key;
      }
    }

    // In mixed multilingual text containing English loanwords, brands, or code:
    // If a distinctive non-Latin script constitutes >= 25% of scored characters,
    // prioritize the native script over generic Latin ASCII.
    if (highestScript == LanguageScript.latin &&
        prominentNonLatin != null &&
        (maxNonLatinCount / totalChars) >= 0.25) {
      highestScript = prominentNonLatin;
      highestCount = maxNonLatinCount;
    }

    final confidence = highestCount / totalChars;

    return ScriptDetectionResult(
      script: highestScript,
      confidence: confidence,
      distribution: distribution,
      totalScoredCharacters: totalChars,
    );
  }

  static LanguageScript? _identifyScriptRune(int r) {
    // Indic Scripts
    if (r >= 0x0980 && r <= 0x09FF) return LanguageScript.bengali;
    if (r >= 0x0900 && r <= 0x097F) return LanguageScript.hindi;
    if (r >= 0x0A00 && r <= 0x0A7F) return LanguageScript.punjabi;
    if (r >= 0x0A80 && r <= 0x0AFF) return LanguageScript.gujarati;
    if (r >= 0x0B00 && r <= 0x0B7F) return LanguageScript.odia;
    if (r >= 0x0B80 && r <= 0x0BFF) return LanguageScript.tamil;
    if (r >= 0x0C00 && r <= 0x0C7F) return LanguageScript.telugu;
    if (r >= 0x0C80 && r <= 0x0CFF) return LanguageScript.kannada;
    if (r >= 0x0D00 && r <= 0x0D7F) return LanguageScript.malayalam;
    if (r >= 0x0D80 && r <= 0x0DFF) return LanguageScript.sinhala;

    // Southeast Asian & Indochina
    if (r >= 0x0E00 && r <= 0x0E7F) return LanguageScript.thai;
    if (r >= 0x0EA0 && r <= 0x0EFF) return LanguageScript.lao;
    if (r >= 0x1000 && r <= 0x109F) return LanguageScript.burmese;
    if (r >= 0x1780 && r <= 0x17FF) return LanguageScript.khmer;

    // African (Ge'ez Fidel)
    if (r >= 0x1200 && r <= 0x137F) return LanguageScript.amharic;

    // Middle Eastern
    if ((r >= 0x0600 && r <= 0x06FF) ||
        (r >= 0x0750 && r <= 0x077F) ||
        (r >= 0x08A0 && r <= 0x08FF) ||
        (r >= 0xFB50 && r <= 0xFDFF) ||
        (r >= 0xFE70 && r <= 0xFEFF)) {
      return LanguageScript.arabic;
    }
    if (r >= 0x0590 && r <= 0x05FF) return LanguageScript.hebrew;

    // European / World Scripts
    if ((r >= 0x0400 && r <= 0x04FF) || (r >= 0x0500 && r <= 0x052F)) {
      return LanguageScript.russian;
    }
    if ((r >= 0x0370 && r <= 0x03FF) || (r >= 0x1F00 && r <= 0x1FFF)) {
      return LanguageScript.greek;
    }
    if ((r >= 0x10A0 && r <= 0x10FF) || (r >= 0x2D00 && r <= 0x2D2F)) {
      return LanguageScript.georgian;
    }
    if (r >= 0x0530 && r <= 0x058F) return LanguageScript.armenian;

    // East Asian
    if ((r >= 0x3040 && r <= 0x309F) || (r >= 0x30A0 && r <= 0x30FF)) {
      return LanguageScript.japanese;
    }
    if ((r >= 0xAC00 && r <= 0xD7AF) ||
        (r >= 0x1100 && r <= 0x11FF) ||
        (r >= 0x3130 && r <= 0x318F)) {
      return LanguageScript.korean;
    }
    if (r >= 0x4E00 && r <= 0x9FFF) return LanguageScript.chinesePinyin;

    // Latin Script (including Latin Extended A & B, Vietnamese vowels)
    if ((r >= 0x0041 && r <= 0x005A) ||
        (r >= 0x0061 && r <= 0x007A) ||
        (r >= 0x00C0 && r <= 0x024F) ||
        (r >= 0x1EA0 && r <= 0x1EF9)) {
      return LanguageScript.latin;
    }

    return null;
  }
}
