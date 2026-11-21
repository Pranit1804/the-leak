import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/caption_picker.dart';
import 'package:the_leak/domain/engine/headline_writer.dart';
import 'package:the_leak/domain/engine/number_words.dart';
import 'package:the_leak/domain/models/caption.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/vote.dart';

import 'helpers.dart';

void main() {
  const names = {1: 'Rohan', 2: 'Priya', 3: 'Amit', 4: 'Sneha', 5: 'Kunal', 6: 'Neha'};
  List<Vote> v(Map<int, int> m) => [for (final e in m.entries) Vote(voterId: e.key, targetId: e.value)];

  group('writeHeadline', () {
    test('caught matches the 09 mockup sentence', () {
      final r = makeRound(participants: [1, 2, 3, 4, 5, 6], master: 2, insider: 4, carMode: true, driver: 1, guessedBy: 3, questions: 7);
      final h = writeHeadline(r, v({1: 4, 3: 4, 5: 4, 6: 3, 2: 4, 4: 6}), names: names, questionLimit: 20);
      expect(h.title, 'CAUGHT!');
      expect(h.deck, 'Sneha exposed as the leak in a 4–2 vote after the car cracked the word in just seven questions.');
    });

    test('says "group" when Car mode is off and writes numbers of ten and up as digits', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, guessedBy: 3, questions: 12);
      final h = writeHeadline(r, v({2: 3, 3: 2, 4: 2, 1: 2}), names: names, questionLimit: 20);
      expect(h.deck, 'Priya exposed as the leak in a 3–1 vote after the group cracked the word in 12 questions.');
    });

    test('escaped: someone else took the blame', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, guessedBy: 3, questions: 1);
      final h = writeHeadline(r, v({2: 3, 3: 4, 4: 3, 1: 3}), names: names, questionLimit: 20);
      expect(h.title, 'ESCAPED!');
      expect(h.deck, 'Priya walked free as the group pinned it on Amit in a 3–1 vote, after cracking the word in one question.');
    });

    test('escaped: split vote including the Insider', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, guessedBy: 3, questions: 9);
      final h = writeHeadline(r, v({2: 3, 3: 2, 4: 3, 1: 2}), names: names, questionLimit: 20);
      expect(h.title, 'ESCAPED!');
      expect(h.deck, 'Priya slipped through a split vote after the group cracked the word in nine questions.');
    });

    test('not found: out of questions, or gave up', () {
      final out = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, questions: 20, carMode: true, driver: 4);
      expect(writeHeadline(out, const [], names: names, questionLimit: 20).deck,
          'The car burned through all 20 questions without cracking the word. Priya kept the secret.');
      final gave = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, questions: 8);
      final h = writeHeadline(gave, const [], names: names, questionLimit: 20);
      expect(h.title, 'NOT FOUND');
      expect(h.deck, 'The group gave up after eight questions. Priya kept the secret all along.');
    });
  });

  group('number words', () {
    test('under ten as words, ten and up as digits', () {
      expect([0, 1, 7, 9, 10, 20].map(numberWord).toList(), ['zero', 'one', 'seven', 'nine', '10', '20']);
      expect(numberWordCap(5), 'Five');
      expect(questionsPhrase(1), 'one question');
      expect(joinNames(['A', 'B', 'C']), 'A, B and C');
    });
  });

  group('captions', () {
    final pool = [
      for (var i = 0; i < 3; i++) Caption(id: 'caught_$i', outcome: Outcome.caught, text: '{insider} cap $i'),
      const Caption(id: 'escaped_0', outcome: Outcome.notCaught, text: 'x'),
    ];

    test('no repeats within a trip until the pool runs out, then it starts over', () {
      final used = <String>{};
      final rng = Random(5);
      for (var i = 0; i < 3; i++) {
        final p = pickCaption(pool: pool, outcome: Outcome.caught, usedIds: used, rng: rng)!;
        expect(p.caption.outcome, Outcome.caught);
        expect(used.add(p.caption.id), isTrue);
        expect(p.clearedIds, isEmpty);
      }
      final again = pickCaption(pool: pool, outcome: Outcome.caught, usedIds: used, rng: rng)!;
      expect(again.clearedIds, hasLength(3));
    });

    test('no captions for an outcome returns null', () {
      expect(pickCaption(pool: pool, outcome: Outcome.notFound, usedIds: {}, rng: Random(1)), isNull);
    });

    test('fills the Insider name', () {
      expect(fillCaption('{insider}, seconds after the reveal.', insiderName: 'Sneha'), 'Sneha, seconds after the reveal.');
    });
  });
}
