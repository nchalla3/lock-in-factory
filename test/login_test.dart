import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lif_mvp/features/auth/login_screen.dart';

// Mock Firebase for testing
void main() {
  group('Login Screen Tests', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Initialize Firebase for testing if not already initialized
      try {
        await Firebase.initializeApp();
      } catch (e) {
        // Firebase might already be initialized in tests
        debugPrint('Firebase already initialized: $e');
      }
    });

    testWidgets('Login screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verify that login screen elements are present
      expect(find.text('Lock-In Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign in with Email'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('Email validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Try to login with empty fields
      await tester.tap(find.text('Sign in with Email'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter both email and password'), findsOneWidget);
    });

    testWidgets('Loading state works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Enter valid email and password
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Sign in with Email'));
      await tester.pump();

      // Should show loading state
      expect(find.text('Signing in...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });
  });
}