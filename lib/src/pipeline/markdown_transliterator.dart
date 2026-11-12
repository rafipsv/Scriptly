import '../core/conversion_options.dart';
import '../core/language_script.dart';
import '../core/transliterator.dart';

/// Transliterates human text inside Markdown (.md) or rich documents while
/// guaranteeing that code blocks, inline code, URLs, link destinations, and HTML tags
/// remain completely untouched.
class MarkdownTransliterator {
  final Transliterator _transliterator;

  MarkdownTransliterator({Transliterator? transliterator})
    : _transliterator = transliterator ?? Transliterator();

  // Fenced code blocks: ```lang ... ```
  static final RegExp _fencedCodeRegex = RegExp(
    r'```[\s\S]*?```',
    multiLine: true,
  );

  // Inline code: `...`
  static final RegExp _inlineCodeRegex = RegExp(r'`[^`\n]+`');

  // Markdown image/link: [text](url) -> protects the URL part
  static final RegExp _markdownLinkRegex = RegExp(r'(!?\[[^\]]*\])\(([^)]+)\)');

  // Raw URLs: http:// or https://
  static final RegExp _rawUrlRegex = RegExp(r'https?://[^\s)\]]+');

  // HTML tags: <tag ...> or </tag>
  static final RegExp _htmlTagRegex = RegExp(r'<[^>]+>');

  /// Transliterates [markdown] from [from] to [to] preserving all formatting.
  String convert(
    String markdown, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = const ConversionOptions(),
  }) {
    if (markdown.isEmpty) return markdown;

    final placeholders = <String, String>{};
    var counter = 0;

    String addPlaceholder(String content, String type) {
      final token = String.fromCharCode(0xE300 + (counter++));
      placeholders[token] = content;
      return token;
    }

    var processed = markdown;

    // 1. Protect Fenced Code Blocks
    processed = processed.replaceAllMapped(_fencedCodeRegex, (m) {
      return addPlaceholder(m[0]!, 'CODEBLOCK');
    });

    // 2. Protect Inline Code
    processed = processed.replaceAllMapped(_inlineCodeRegex, (m) {
      return addPlaceholder(m[0]!, 'INLINECODE');
    });

    // 3. Protect Markdown Link URLs (keep label for transliteration)
    processed = processed.replaceAllMapped(_markdownLinkRegex, (m) {
      final label = m[1]!;
      final url = m[2]!;
      final urlToken = addPlaceholder(url, 'URL');
      return '$label($urlToken)';
    });

    // 4. Protect Raw URLs
    processed = processed.replaceAllMapped(_rawUrlRegex, (m) {
      return addPlaceholder(m[0]!, 'RAWURL');
    });

    // 5. Protect HTML tags
    processed = processed.replaceAllMapped(_htmlTagRegex, (m) {
      return addPlaceholder(m[0]!, 'HTML');
    });

    // 6. Transliterate human content
    final converted = _transliterator.convert(
      processed,
      from: from,
      to: to,
      options: options,
    );

    var result = converted.text;

    // 7. Restore all protected blocks
    for (final entry in placeholders.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    return result;
  }
}
