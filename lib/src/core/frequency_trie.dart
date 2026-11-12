/// Compact Trie node storing candidate suggestions with frequency weights.
class TrieNode {
  final Map<String, TrieNode> children = {};
  final List<WeightedCandidate> candidates = [];
}

/// A candidate suggestion associated with a frequency score.
class WeightedCandidate implements Comparable<WeightedCandidate> {
  final String text;
  final int frequency;

  const WeightedCandidate(this.text, this.frequency);

  @override
  int compareTo(WeightedCandidate other) =>
      other.frequency.compareTo(frequency);
}

/// In-memory Radix Trie for ranking phonetic word candidates by linguistic frequency.
class FrequencyTrie {
  final TrieNode _root = TrieNode();

  /// Creates an empty [FrequencyTrie].
  FrequencyTrie();

  /// Inserts a candidate into the Trie with an associated frequency score.
  void insert(String prefix, String candidate, int frequency) {
    if (prefix.isEmpty) return;

    var current = _root;
    final lower = prefix.toLowerCase();

    for (var i = 0; i < lower.length; i++) {
      final char = lower[i];
      current = current.children.putIfAbsent(char, TrieNode.new);
    }

    // Update existing candidate or add new
    final existingIdx = current.candidates.indexWhere(
      (c) => c.text == candidate,
    );
    if (existingIdx != -1) {
      if (current.candidates[existingIdx].frequency < frequency) {
        current.candidates[existingIdx] = WeightedCandidate(
          candidate,
          frequency,
        );
      }
    } else {
      current.candidates.add(WeightedCandidate(candidate, frequency));
    }

    current.candidates.sort();
  }

  /// Retrieves candidates for a given [prefix], sorted by frequency descending.
  List<String> getCandidates(String prefix, {int limit = 5}) {
    if (prefix.isEmpty) return const [];

    var current = _root;
    final lower = prefix.toLowerCase();

    for (var i = 0; i < lower.length; i++) {
      final char = lower[i];
      final next = current.children[char];
      if (next == null) return const [];
      current = next;
    }

    return current.candidates.take(limit).map((c) => c.text).toList();
  }

  /// Creates a default pre-populated [FrequencyTrie] with common conversational terms.
  factory FrequencyTrie.withDefaults() {
    final trie = FrequencyTrie();

    // Bengali Common Homophones & Frequencies
    trie.insert('kori', 'করি', 100);
    trie.insert('kori', 'কড়ি', 15);
    trie.insert('ami', 'আমি', 100);
    trie.insert('tumi', 'তুমি', 95);
    trie.insert('apni', 'আপনি', 90);
    trie.insert('bhalo', 'ভালো', 100);
    trie.insert('pori', 'পড়ি', 80);
    trie.insert('pori', 'পরি', 50);

    // Hindi Common Terms
    trie.insert('namaste', 'नमस्ते', 100);
    trie.insert('kya', 'क्या', 95);
    trie.insert('hai', 'है', 100);
    trie.insert('hain', 'हैं', 90);
    trie.insert('bharat', 'भारत', 100);

    // Arabic / Perso-Arabic Common Terms
    trie.insert('salam', 'سلام', 100);
    trie.insert('marhaban', 'مرحبا', 95);
    trie.insert('shukran', 'شكرا', 90);

    return trie;
  }
}
