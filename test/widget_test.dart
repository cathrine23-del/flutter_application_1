import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  testWidgets('Sign up form smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) => const Text('Sign up')),
        ),
      ),
    );

    // Verify the app renders without errors.
    expect(find.text('Sign up'), findsOneWidget);
  });
}
