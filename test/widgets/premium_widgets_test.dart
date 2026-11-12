import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('Premium Flutter Widgets Tests', () {
    testWidgets(
      'ScriptlyVirtualKeyboard types characters and handles backspace',
      (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScriptlyVirtualKeyboard(controller: controller),
            ),
          ),
        );

        // Tap 'A' key
        await tester.tap(find.text('A'));
        await tester.pump();
        expect(controller.text, equals('a'));

        // Tap 'B' key
        await tester.tap(find.text('B'));
        await tester.pump();
        expect(controller.text, equals('ab'));

        // Tap Backspace
        await tester.tap(find.byIcon(Icons.backspace_rounded));
        await tester.pump();
        expect(controller.text, equals('a'));

        // Tap Space
        await tester.tap(find.text('Space'));
        await tester.pump();
        expect(controller.text, equals('a '));
      },
    );

    testWidgets(
      'ScriptlyDiffViewer renders both side-by-side and inline modes',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ScriptlyDiffViewer(
                sourceText: 'Ami bhalo achi',
                targetText: 'আমি ভালো আছি',
              ),
            ),
          ),
        );

        expect(find.text('SOURCE'), findsOneWidget);
        expect(find.text('TRANSLITERATED'), findsOneWidget);
        expect(find.text('Ami bhalo achi'), findsOneWidget);
        expect(find.text('আমি ভালো আছি'), findsOneWidget);

        // Test inline mode
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ScriptlyDiffViewer(
                sourceText: 'Ami bhalo',
                targetText: 'আমি ভালো',
                isInline: true,
              ),
            ),
          ),
        );
        expect(find.text('Ami'), findsOneWidget);
        expect(find.text('আমি'), findsOneWidget);
      },
    );

    testWidgets(
      'ScriptlyAutocompleteTextField renders input and suggestion ghost chip',
      (tester) async {
        final controller = TextEditingController(text: 'ami');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScriptlyAutocompleteTextField(
                controller: controller,
                predictionProvider: (text) async {
                  if (text == 'ami') return 'ami banglay';
                  return null;
                },
              ),
            ),
          ),
        );

        // Trigger listener
        controller.text = 'ami ';
        await tester.pump();

        expect(find.byType(TextField), findsOneWidget);
      },
    );
  });
}
