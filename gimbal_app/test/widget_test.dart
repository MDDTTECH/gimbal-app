import 'package:flutter_test/flutter_test.dart';
import 'package:gimbal_app/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const GimbalApp());
    expect(find.text('GIMBAL'), findsOneWidget);
  });
}
