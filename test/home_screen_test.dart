import 'package:codealpha_random_quote_generator/data/quotes_data.dart';
import 'package:codealpha_random_quote_generator/providers/quote_provider.dart';
import 'package:codealpha_random_quote_generator/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('categories stay in one row and selected chips are not clipped', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    final provider = QuoteProvider(prefs);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    double? categoryRowTop;
    final viewportFinder = find.byKey(const ValueKey('category-bar-viewport'));

    for (final category in kCategories) {
      provider.setCategory(category);
      await tester.pumpAndSettle();

      final selectedChip = find.widgetWithText(ChoiceChip, category);
      final chipRect = tester.getRect(selectedChip);
      final viewportRect = tester.getRect(viewportFinder);

      expect(tester.widget<ChoiceChip>(selectedChip).selected, isTrue);
      expect(chipRect.left, greaterThanOrEqualTo(viewportRect.left));
      expect(chipRect.right, lessThanOrEqualTo(viewportRect.right));

      categoryRowTop ??= chipRect.top;
      expect(chipRect.top, closeTo(categoryRowTop, 0.1));
    }
  });
}
