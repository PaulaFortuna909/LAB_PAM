import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lab2/main.dart';

void main() {
  testWidgets('Home screen renders', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(const Lab2App());
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);
  });
}
