import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/word_picker.dart';
import 'package:the_leak/domain/models/difficulty.dart';

import 'helpers.dart';

void main() {
  final deck = dummyDeck(perDifficulty: 5);

  test('picks only the chosen difficulty and never repeats until it runs out', () {
    final used = <String>{};
    final rng = Random(3);
    for (var i = 0; i < 5; i++) {
      final pick = pickWord(deck: deck, choice: DifficultyChoice.hard, usedWordIds: used, rng: rng);
      expect(pick.word.difficulty, Difficulty.hard);
      expect(used.contains(pick.word.id), isFalse);
      expect(pick.reshuffled, isFalse);
      used.add(pick.word.id);
    }
    expect(remainingWords(deck, DifficultyChoice.hard, used), 0);
    expect(remainingWords(deck, DifficultyChoice.easy, used), 5);
  });

  test('when a difficulty runs out it reshuffles and flags it once', () {
    final used = deck.where((w) => w.difficulty == Difficulty.easy).map((w) => w.id).toSet();
    final pick = pickWord(deck: deck, choice: DifficultyChoice.easy, usedWordIds: used, rng: Random(1));
    expect(pick.reshuffled, isTrue);
    expect(pick.clearedIds, used);
    expect(pick.word.difficulty, Difficulty.easy);

    // After clearing, the next pick is a normal one again.
    final after = {...used}..removeAll(pick.clearedIds)..add(pick.word.id);
    final next = pickWord(deck: deck, choice: DifficultyChoice.easy, usedWordIds: after, rng: Random(2));
    expect(next.reshuffled, isFalse);
    expect(next.word.id, isNot(pick.word.id));
  });

  test('Mixed draws from every difficulty and skips used words', () {
    final seen = <Difficulty>{};
    final used = <String>{};
    final rng = Random(9);
    for (var i = 0; i < deck.length; i++) {
      final pick = pickWord(deck: deck, choice: DifficultyChoice.mixed, usedWordIds: used, rng: rng);
      expect(used.add(pick.word.id), isTrue);
      seen.add(pick.word.difficulty);
    }
    expect(seen, Difficulty.values.toSet());
    expect(pickWord(deck: deck, choice: DifficultyChoice.mixed, usedWordIds: used, rng: rng).reshuffled, isTrue);
  });

  test('seeded picks are reproducible', () {
    final a = pickWord(deck: deck, choice: DifficultyChoice.medium, usedWordIds: {}, rng: Random(42));
    final b = pickWord(deck: deck, choice: DifficultyChoice.medium, usedWordIds: {}, rng: Random(42));
    expect(a.word.id, b.word.id);
  });
}
