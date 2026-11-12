import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly_core.dart';

void main() {
  group('Security & Compliance Module Tests', () {
    test(
      'PiiShield shields and restores credit cards with Luhn validation',
      () {
        // 4532-0150-1234-5671 is a valid 16-digit Luhn card number
        const card = '4532-0150-1234-5671';
        final isLuhn = PiiShield.isValidLuhn(card);
        expect(isLuhn, isTrue);

        const text = 'Payment with card 4532-0150-1234-5671 for order';
        final shielded = PiiShield.shield(text);

        expect(shielded.text.contains('4532-0150-1234-5671'), isFalse);
        expect(shielded.tokens.isNotEmpty, isTrue);

        final restored = PiiShield.restore(shielded.text, shielded.tokens);
        expect(restored, equals(text));
      },
    );

    test(
      'PiiShield protects emails and phone numbers from transliteration',
      () {
        const text = 'Contact john.doe@example.com or call +1-555-123-4567';
        final shielded = Scriptly.shieldPii(text);

        expect(shielded.text.contains('john.doe@example.com'), isFalse);
        expect(shielded.text.contains('+1-555-123-4567'), isFalse);

        final converted = Scriptly.convert(
          shielded.text,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        final restored = Scriptly.restorePii(converted.text, shielded.tokens);
        expect(restored.contains('john.doe@example.com'), isTrue);
        expect(restored.contains('+1-555-123-4567'), isTrue);
      },
    );

    test('PiiShield protects OTP codes with keyword matching', () {
      const text = 'Your secure OTP: 849201 for verification';
      final shielded = PiiShield.shield(text);

      expect(shielded.text.contains('849201'), isFalse);
      final restored = PiiShield.restore(shielded.text, shielded.tokens);
      expect(restored, equals(text));
    });

    test('PhoneticIdentityHasher matches phonetic name variants for KYC', () {
      final h1 = Scriptly.identityHash('Mohammad');
      final h2 = Scriptly.identityHash('Muhammad');
      final h3 = Scriptly.identityHash('Md. Mohammad');
      final h4 = Scriptly.identityHash('Mohamad');

      expect(h1, equals(h2));
      expect(h1, equals(h3));
      expect(h1, equals(h4));
      expect(Scriptly.isSameIdentity('Mohammad', 'Muhammad'), isTrue);

      // Different person
      final hOther = Scriptly.identityHash('Alexander');
      expect(h1, isNot(equals(hOther)));
    });
  });
}
