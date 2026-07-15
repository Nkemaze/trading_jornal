import 'package:flutter_test/flutter_test.dart';
import 'package:trading_journal/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenithApp());
    await tester.pump();
    expect(find.text('Zenith'), findsOneWidget);
  });
}
