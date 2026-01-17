import 'package:flutter_test/flutter_test.dart';

import 'package:food_jury/app.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodJuryApp());

    // Verify that the app title is displayed.
    expect(find.text('FOOD JURY'), findsOneWidget);
  });
}
