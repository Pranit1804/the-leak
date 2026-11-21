import 'dart:math';

import '../models/difficulty.dart';
import '../models/word.dart';

class WordPick {
  const WordPick({required this.word, required this.reshuffled, required this.clearedIds});

  final Word word;

  /// True when every word of the chosen difficulty had been used, so the
  /// pool was reshuffled for this pick.
  final bool reshuffled;

  /// Word ids whose "used" mark should be cleared because of the reshuffle.
  final Set<String> clearedIds;
}

List<Word> _pool(List<Word> deck, DifficultyChoice choice) {
  final d = choice.difficulty;
  final pool = d == null ? [...deck] : deck.where((w) => w.difficulty == d).toList();
  pool.sort((a, b) => a.id.compareTo(b.id));
  return pool;
}

/// How many unused words are left for [choice] in this trip.
int remainingWords(List<Word> deck, DifficultyChoice choice, Set<String> usedWordIds) =>
    _pool(deck, choice).where((w) => !usedWordIds.contains(w.id)).length;

/// Picks an unused word of [choice]. When the difficulty runs out, the pool
/// is reshuffled (all its words become available again) and the pick is
/// flagged with [WordPick.reshuffled].
WordPick pickWord({
  required List<Word> deck,
  required DifficultyChoice choice,
  required Set<String> usedWordIds,
  required Random rng,
}) {
  final pool = _pool(deck, choice);
  if (pool.isEmpty) throw StateError('No words for ${choice.name}');
  var unused = pool.where((w) => !usedWordIds.contains(w.id)).toList();
  var reshuffled = false;
  var cleared = <String>{};
  if (unused.isEmpty) {
    reshuffled = true;
    cleared = pool.map((w) => w.id).toSet();
    unused = pool;
  }
  return WordPick(word: unused[rng.nextInt(unused.length)], reshuffled: reshuffled, clearedIds: cleared);
}
