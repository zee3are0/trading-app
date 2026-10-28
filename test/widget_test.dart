import 'package:flutter_test/flutter_test.dart';
import 'package:tradingbot/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TradingApp());
    await tester.pumpAndSettle();
  });
}
