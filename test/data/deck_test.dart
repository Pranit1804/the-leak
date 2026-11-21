import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/data/repositories/content_repositories.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/word.dart';

/// Sealed deck checks: counts and structure only. No assertion or failure
/// message ever contains a word.
void main() {
  final raw = jsonDecode(File('assets/decks/words_v1.json').readAsStringSync()) as List<dynamic>;
  final entries = raw.cast<Map<String, dynamic>>();
  final deck = DeckRepository.parseDeck(raw);

  test('about 300 words, at least 100 per difficulty', () {
    expect(deck.length, inInclusiveRange(280, 340));
    for (final d in Difficulty.values) {
      expect(deck.where((w) => w.difficulty == d).length, greaterThanOrEqualTo(100), reason: '${d.name} count');
    }
  });

  test('every category from PRD section 6 is well represented', () {
    for (final c in DeckCategories.all) {
      final n = deck.where((w) => w.category == c).length;
      expect(n, greaterThanOrEqualTo(30), reason: '$c count');
      for (final d in Difficulty.values) {
        expect(deck.where((w) => w.category == c && w.difficulty == d).length, greaterThanOrEqualTo(8), reason: '$c/${d.name} count');
      }
    }
    expect(deck.where((w) => !DeckCategories.all.contains(w.category)).length, 0, reason: 'unknown categories');
  });

  test('ids are unique and follow <category>_NNN', () {
    expect(deck.map((w) => w.id).toSet().length, deck.length, reason: 'duplicate ids');
    final bad = deck.where((w) => !RegExp('^${w.category}_\\d{3}\$').hasMatch(w.id)).length;
    expect(bad, 0, reason: 'ids not matching their category');
  });

  test('every entry has exactly the four fields with valid values', () {
    var badKeys = 0, badWords = 0;
    for (final e in entries) {
      if (e.keys.toSet().difference({'id', 'word', 'category', 'difficulty'}).isNotEmpty || e.length != 4) badKeys++;
      final w = e['word'];
      if (w is! String || w.trim() != w || w.isEmpty || w.length > 24 || !RegExp(r"^[A-Za-z0-9 '&.\-]+$").hasMatch(w)) badWords++;
    }
    expect(badKeys, 0, reason: 'entries with wrong fields');
    expect(badWords, 0, reason: 'words that are empty, too long or have odd characters');
  });

  test('no duplicate words (case-insensitive)', () {
    final normalised = deck.map((w) => w.word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')).toList();
    expect(normalised.length - normalised.toSet().length, 0, reason: 'duplicate words');
  });

  test('no placeholder entries remain', () {
    expect(deck.where((w) => RegExp(r'^word_\d+$').hasMatch(w.word)).length, 0, reason: 'placeholder entries');
  });
}
