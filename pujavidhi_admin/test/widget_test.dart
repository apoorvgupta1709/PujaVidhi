import 'package:flutter_test/flutter_test.dart';
import 'package:pujavidhi_admin/main.dart';

void main() {
  testWidgets('PujaVidhi Admin console smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PujaVidhiAdminApp());
    expect(find.text('PujaVidhi Operator Control Console'), findsWidgets);
  });
}
