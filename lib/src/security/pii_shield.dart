/// Utility for detecting and shielding Personally Identifiable Information (PII)
/// during transliteration pipelines to prevent data scrambling and leaks.
class PiiShield {
  PiiShield._();

  // Credit card: 13-19 digits with optional hyphens/spaces satisfying Luhn algorithm
  static final RegExp _cardRegex = RegExp(r'\b(?:\d[ -]*?){13,19}\b');

  // RFC 5322 compliant simplified email regex
  static final RegExp _emailRegex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
  );

  // International E.164 and local phone numbers
  static final RegExp _phoneRegex = RegExp(
    r'(?:\+?\d{1,4}[ -]?)?(?:\(?\d{2,5}\)?[ -]?)?\d{3,5}[ -]?\d{3,5}\b',
  );

  // 4-8 digit OTPs / PIN codes preceded by standard keywords
  static final RegExp _otpRegex = RegExp(
    r'\b(?:otp|pin|code|token)\s*[:=]?\s*(\d{4,8})\b',
    caseSensitive: false,
  );

  /// Validates a potential credit card string against the Luhn algorithm.
  static bool isValidLuhn(String cardNumber) {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.length < 13 || clean.length > 19) return false;

    var sum = 0;
    var alternate = false;
    for (var i = clean.length - 1; i >= 0; i--) {
      var n = int.parse(clean[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  /// Shields sensitive PII in [input] by replacing them with opaque tokens.
  /// Returns the tokenized string and a map of tokens to original values.
  static PiiShieldResult shield(String input) {
    final tokens = <String, String>{};
    var counter = 0;

    String replaceWithToken(String match, String type) {
      final token = String.fromCharCode(0xE100 + (counter++));
      tokens[token] = match;
      return token;
    }

    var processed = input;

    // 1. Shield Emails
    processed = processed.replaceAllMapped(_emailRegex, (m) {
      return replaceWithToken(m[0]!, 'EMAIL');
    });

    // 2. Shield OTPs
    processed = processed.replaceAllMapped(_otpRegex, (m) {
      final whole = m[0]!;
      final digits = m[1]!;
      final token = replaceWithToken(digits, 'OTP');
      return whole.replaceFirst(digits, token);
    });

    // 3. Shield Credit Cards (Valid Luhn only)
    processed = processed.replaceAllMapped(_cardRegex, (m) {
      final candidate = m[0]!;
      if (isValidLuhn(candidate)) {
        return replaceWithToken(candidate, 'CARD');
      }
      return candidate;
    });

    // 4. Shield Phone numbers (at least 7 digits to avoid small numbers)
    processed = processed.replaceAllMapped(_phoneRegex, (m) {
      final candidate = m[0]!;
      final digitsOnly = candidate.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length >= 7 && digitsOnly.length <= 15) {
        return replaceWithToken(candidate, 'PHONE');
      }
      return candidate;
    });

    return PiiShieldResult(text: processed, tokens: tokens);
  }

  /// Restores shielded tokens in [text] using [tokens] mapping.
  static String restore(String text, Map<String, String> tokens) {
    var restored = text;
    for (final entry in tokens.entries) {
      restored = restored.replaceAll(entry.key, entry.value);
    }
    return restored;
  }
}

/// Result of a PII shielding operation.
class PiiShieldResult {
  final String text;
  final Map<String, String> tokens;

  const PiiShieldResult({required this.text, required this.tokens});
}
