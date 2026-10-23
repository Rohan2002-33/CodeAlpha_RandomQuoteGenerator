import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quote.dart';
import '../data/quotes_data.dart';

/// Holds the current quote, selected category and saved favorites.
class QuoteProvider extends ChangeNotifier {
  QuoteProvider(this._prefs) {
    final saved = _prefs.getStringList(_favoritesKey) ?? const <String>[];
    _favoriteIds.addAll(saved.map(int.tryParse).whereType<int>());
    // Random quote every time the app opens.
    _current = _pickRandom();
  }

  static const String _favoritesKey = 'favorite_quote_ids';

  final SharedPreferences _prefs;
  final Random _random = Random();
  final Set<int> _favoriteIds = <int>{};
  String _category = 'All';
  late Quote _current;

  Quote get current => _current;
  String get category => _category;
  int get favoriteCount => _favoriteIds.length;

  List<Quote> get favorites =>
      kQuotes.where((q) => _favoriteIds.contains(q.id)).toList(growable: false);

  bool isFavorite(Quote quote) => _favoriteIds.contains(quote.id);

  List<Quote> get _pool => _category == 'All'
      ? kQuotes
      : kQuotes.where((q) => q.category == _category).toList();

  Quote _pickRandom({Quote? exclude}) {
    final candidates = _pool.where((q) => q.id != exclude?.id).toList();
    final source = candidates.isEmpty ? _pool : candidates;
    return source[_random.nextInt(source.length)];
  }

  /// Shows a random quote that is different from the current one.
  void newQuote() {
    _current = _pickRandom(exclude: _current);
    notifyListeners();
  }

  void setCategory(String category) {
    if (category == _category) return;
    _category = category;
    _current = _pickRandom(exclude: _current);
    notifyListeners();
  }

  void toggleFavorite(Quote quote) {
    if (!_favoriteIds.add(quote.id)) {
      _favoriteIds.remove(quote.id);
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(Quote quote) {
    if (_favoriteIds.remove(quote.id)) {
      _saveFavorites();
      notifyListeners();
    }
  }

  void clearFavorites() {
    _favoriteIds.clear();
    _saveFavorites();
    notifyListeners();
  }

  void _saveFavorites() {
    _prefs.setStringList(
      _favoritesKey,
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }
}
