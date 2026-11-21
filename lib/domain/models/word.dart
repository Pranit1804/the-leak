import 'difficulty.dart';

/// One entry of the sealed deck. Never log or print [word].
class Word {
  const Word({required this.id, required this.word, required this.category, required this.difficulty});

  final String id;
  final String word;
  final String category;
  final Difficulty difficulty;

  /// Deliberately omits [word] so it can never leak into logs.
  @override
  String toString() => 'Word($id)';
}

/// Deck categories from PRD section 6.
abstract final class DeckCategories {
  static const all = ['food', 'bollywood_ott', 'cricket_sports', 'places', 'daily_life', 'brands', 'tech_internet', 'professions'];
}
