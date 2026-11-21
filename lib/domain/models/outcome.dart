/// How a round ended. Stored as `caught` / `not_caught` / `not_found` / `abandoned`.
enum Outcome {
  caught('caught'),
  notCaught('not_caught'),
  notFound('not_found'),
  abandoned('abandoned');

  const Outcome(this.db);
  final String db;

  static Outcome parse(String s) => Outcome.values.firstWhere((o) => o.db == s);

  /// The word was found (caught or not caught).
  bool get wordFound => this == caught || this == notCaught;

  /// Counts towards points and stats.
  bool get scored => this != abandoned;
}
