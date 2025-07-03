import 'package:flutter_test/flutter_test.dart';
import 'package:lif_mvp/main.dart';

void main() {
  testWidgets('MyApp can be instantiated', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app doesn't crash on startup
    expect(find.byType(MyApp), findsOneWidget);
  });
}