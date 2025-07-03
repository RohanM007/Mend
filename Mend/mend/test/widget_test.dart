// Basic Flutter widget test for Mend app.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mend/main.dart';

void main() {
  testWidgets('Mend app smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MendApp(prefs: prefs));

    // Verify that the splash screen appears
    expect(find.text('Mend'), findsOneWidget);
    expect(
      find.text('Your personal mental wellness companion'),
      findsOneWidget,
    );
  });
}
