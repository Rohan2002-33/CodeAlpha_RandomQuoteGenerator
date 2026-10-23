import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:codealpha_random_quote_generator/data/quotes_data.dart';
import 'package:codealpha_random_quote_generator/providers/quote_provider.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('dataset has unique ids', () {
    final ids = kQuotes.map((q) => q.id).toSet();
    expect(ids.length, kQuotes.length);
  });

  test('newQuote never repeats the current quote', () async {
    final prefs = await SharedPreferences.getInstance();
    final provider = QuoteProvider(prefs);

    for (var i = 0; i < 200; i++) {
      final before = provider.current.id;
      provider.newQuote();
      expect(provider.current.id, isNot(before));
    }
  });

  test('category filter only returns quotes of that category', () async {
    final prefs = await SharedPreferences.getInstance();
    final provider = QuoteProvider(prefs)..setCategory('Technology');

    for (var i = 0; i < 50; i++) {
      provider.newQuote();
      expect(provider.current.category, 'Technology');
    }
  });

  test('favorites persist across provider instances', () async {
    final prefs = await SharedPreferences.getInstance();
    final first = QuoteProvider(prefs);
    final quote = first.current;
    first.toggleFavorite(quote);

    final second = QuoteProvider(prefs);
    expect(second.isFavorite(quote), isTrue);
    expect(second.favoriteCount, 1);
  });
}