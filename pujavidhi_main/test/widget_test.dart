import 'package:flutter_test/flutter_test.dart';
import 'package:pujavidhi_main/main.dart';

void main() {
  testWidgets('PujaVidhi app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PujaVidhiApp());
    expect(find.text('PujaVidhi'), findsWidgets);
  });
}
