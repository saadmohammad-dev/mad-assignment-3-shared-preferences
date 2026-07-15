import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:counter_app/main.dart'; // <-- apne project ka naam yahan daalna

void main() {
  testWidgets('Theme loads and dropdown changes color', (WidgetTester tester) async {
    // shared_preferences ko test mode me set karna zaroori hai
    SharedPreferences.setMockInitialValues({'theme_color': 'Red'});

    // runApp me wahi widget dalo jo main.dart me hai
    await tester.pumpWidget(const ColorThemeApp(initialColorName: 'Red'));

    // 1. Check karo ke AppBar ka title aya ya nahi
    expect(find.text('Color Theme Selector'), findsOneWidget);

    // 2. Check karo ke current theme button pe Red likha hai
    expect(find.text('Current Theme: Red'), findsOneWidget);

    // 3. Dropdown ko tap karo aur Green select karo
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle(); // dropdown khulne ka wait

    await tester.tap(find.text('Green').last);
    await tester.pumpAndSettle(); // UI update hone ka wait

    // 4. Check karo ke theme Green ho gaya
    expect(find.text('Current Theme: Green'), findsOneWidget);
  });
}