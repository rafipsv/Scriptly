import 'package:flutter/widgets.dart';

import '../core/language_script.dart';
import '../core/transliterator.dart';

/// A drop-in container displaying real-time phonetic candidate suggestions for input fields.
class ScriptlySuggestionOverlay extends StatefulWidget {
  final Widget child;
  final TextEditingController controller;
  final LanguageScript from;
  final LanguageScript to;
  final Transliterator? transliterator;
  final void Function(String selected)? onSelected;

  const ScriptlySuggestionOverlay({
    super.key,
    required this.child,
    required this.controller,
    required this.from,
    required this.to,
    this.transliterator,
    this.onSelected,
  });

  @override
  State<ScriptlySuggestionOverlay> createState() =>
      _ScriptlySuggestionOverlayState();
}

class _ScriptlySuggestionOverlayState extends State<ScriptlySuggestionOverlay> {
  late final Transliterator _engine = widget.transliterator ?? Transliterator();
  List<String> _candidates = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCandidates);
  }

  void _updateCandidates() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    if (text.isEmpty || !selection.isValid || selection.baseOffset <= 0) {
      if (_candidates.isNotEmpty) setState(() => _candidates = []);
      return;
    }

    // Extract current word up to cursor
    final beforeCursor = text.substring(0, selection.baseOffset);
    final lastWord = beforeCursor.split(RegExp(r'\s+')).last;

    if (lastWord.isEmpty) {
      if (_candidates.isNotEmpty) setState(() => _candidates = []);
      return;
    }

    try {
      final converted = _engine.convert(
        lastWord,
        from: widget.from,
        to: widget.to,
      );
      setState(() => _candidates = [converted.text, lastWord]);
    } catch (_) {
      setState(() => _candidates = []);
    }
  }

  void _selectCandidate(String candidate) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final before = text.substring(0, selection.baseOffset);
    final after = text.substring(selection.baseOffset);

    final words = before.split(RegExp(r'\s+'));
    final lastWord = words.removeLast();
    final prefix = before.substring(0, before.length - lastWord.length);

    final newText = '$prefix$candidate$after';
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: prefix.length + candidate.length,
      ),
    );
    widget.onSelected?.call(candidate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_candidates.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Wrap(
              spacing: 6,
              children: _candidates
                  .map(
                    (c) => GestureDetector(
                      onTap: () => _selectCandidate(c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          c,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        widget.child,
      ],
    );
  }
}
