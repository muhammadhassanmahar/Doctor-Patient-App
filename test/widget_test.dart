import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Login Screen UI Test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the Login screen is displayed
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    // Verify text fields
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify Login button
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}