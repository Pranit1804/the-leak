/// Word difficulty (PRD section 6).
enum Difficulty {
  easy,
  medium,
  hard;

  static Difficulty parse(String s) => Difficulty.values.byName(s);
}

/// What the group picks on Round setup: a single difficulty, or Mixed.
enum DifficultyChoice {
  easy(Difficulty.easy, 'Easy'),
  medium(Difficulty.medium, 'Medium'),
  hard(Difficulty.hard, 'Hard'),
  mixed(null, 'Mixed');

  const DifficultyChoice(this.difficulty, this.label);

  /// Null for Mixed.
  final Difficulty? difficulty;
  final String label;
}
