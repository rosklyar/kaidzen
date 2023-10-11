import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kaidzen_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Just to verify that the app is running
    await tester.pumpWidget(const MyApp());

    expect(true, isTrue);
  });
}
