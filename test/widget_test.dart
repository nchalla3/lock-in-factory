// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:lif_mvp/main.dart';
import 'package:lif_mvp/features/auth/login_screen.dart';

void main() {
  setUpAll(() async {
    // Mock Firebase initialization
    TestWidgetsFlutterBinding.ensureInitialized();
    // Note: In a real test, you'd use Firebase Test Lab or mock Firebase
    // For now, we'll test the UI behavior only
  });

  testWidgets('LoginScreen shows initial choice buttons', (WidgetTester tester) async {
    // Build the LoginScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify initial state shows the choice buttons
    expect(find.text('Welcome to Lock-In Factory'), findsOneWidget);
    expect(find.text('Choose how you\'d like to sign in:'), findsOneWidget);
    expect(find.text('Sign in with Email'), findsOneWidget);
    expect(find.text('Continue with Google'), findsAny); // May vary based on platform

    // Verify email form is not shown initially
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Clicking "Sign in with Email" shows email form', (WidgetTester tester) async {
    // Build the LoginScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Tap the "Sign in with Email" button
    await tester.tap(find.text('Sign in with Email'));
    await tester.pump();

    // Verify email form is now shown
    expect(find.byType(TextField), findsNWidgets(2)); // Email and password fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Verify initial buttons are hidden
    expect(find.text('Welcome to Lock-In Factory'), findsNothing);
    expect(find.text('Choose how you\'d like to sign in:'), findsNothing);
  });

  testWidgets('Back button returns to initial screen', (WidgetTester tester) async {
    // Build the LoginScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Navigate to email form
    await tester.tap(find.text('Sign in with Email'));
    await tester.pump();

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    // Verify we're back to initial state
    expect(find.text('Welcome to Lock-In Factory'), findsOneWidget);
    expect(find.text('Choose how you\'d like to sign in:'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
