/// Immutable quote entity.
class Quote {
  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });

  final int id;
  final String text;
  final String author;
  final String category;
}
