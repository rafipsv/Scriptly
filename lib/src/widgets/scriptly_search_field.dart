import 'package:flutter/widgets.dart';

import '../core/language_script.dart';
import '../core/phonetic_matcher.dart';

/// A cross-script phonetic search field that matches queries across different scripts.
class ScriptlySearchField<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) itemLabel;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final void Function(T item)? onSelected;
  final String hintText;
  final double matchThreshold;
  final LanguageScript? targetScript;

  const ScriptlySearchField({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.itemBuilder,
    this.onSelected,
    this.hintText = 'Search across scripts...',
    this.matchThreshold = 0.65,
    this.targetScript,
  });

  @override
  State<ScriptlySearchField<T>> createState() => _ScriptlySearchFieldState<T>();
}

class _ScriptlySearchFieldState<T> extends State<ScriptlySearchField<T>> {
  final TextEditingController _controller = TextEditingController();
  List<T> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() => _filtered = widget.items);
      return;
    }

    setState(() {
      _filtered = widget.items.where((item) {
        final label = widget.itemLabel(item);
        return PhoneticMatcher.isMatch(
          query,
          label,
          threshold: widget.matchThreshold,
          candidateScript: widget.targetScript,
        );
      }).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EditableText(
          controller: _controller,
          focusNode: FocusNode(),
          style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
          cursorColor: const Color(0xFF2196F3),
          backgroundCursorColor: const Color(0xFFE0E0E0),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (ctx, idx) => GestureDetector(
              onTap: () => widget.onSelected?.call(_filtered[idx]),
              child: widget.itemBuilder(ctx, _filtered[idx]),
            ),
          ),
        ),
      ],
    );
  }
}
