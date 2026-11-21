import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/player.dart';
import 'package:the_leak/domain/models/round.dart';
import 'package:the_leak/domain/models/round_phase.dart';
import 'package:the_leak/domain/models/word.dart';

/// Players with ids 1..n in seat order 0..n-1.
List<Player> makePlayers(int n, {Set<int> drivers = const {}, Set<int> removed = const {}}) => [
      for (var i = 1; i <= n; i++)
        Player(
          id: i,
          name: 'P$i',
          seatOrder: i - 1,
          canDrive: drivers.contains(i),
          removedAt: removed.contains(i) ? DateTime(2026) : null,
        ),
    ];

Round makeRound({
  int id = 1,
  int number = 1,
  required List<int> participants,
  required int master,
  required int insider,
  bool carMode = false,
  int? driver,
  RoundPhase phase = RoundPhase.handout,
  int questions = 0,
  int? guessedBy,
  Outcome? outcome,
  DateTime? startedAt,
}) =>
    Round(
      id: id,
      tripId: 1,
      number: number,
      startedAt: startedAt ?? DateTime(2026, 11, 20, 10),
      carMode: carMode,
      driverId: driver,
      masterId: master,
      insiderId: insider,
      wordId: 'word_001',
      phase: phase,
      questionsUsed: questions,
      guessedById: guessedBy,
      outcome: outcome,
      participantIds: participants,
    );

/// A dummy deck: ids only, the "word" is a placeholder (never real words in tests).
List<Word> dummyDeck({int perDifficulty = 5}) {
  final words = <Word>[];
  var n = 0;
  for (final d in Difficulty.values) {
    for (var i = 0; i < perDifficulty; i++) {
      n++;
      final id = 'word_${n.toString().padLeft(3, '0')}';
      words.add(Word(id: id, word: id, category: DeckCategories.all[n % DeckCategories.all.length], difficulty: d));
    }
  }
  return words;
}
