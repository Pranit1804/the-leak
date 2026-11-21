import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/data/repositories/content_repositories.dart';
import 'package:the_leak/domain/models/outcome.dart';

void main() {
  final captions = CaptionRepository.parseCaptions(jsonDecode(File('assets/copy/captions_v1.json').readAsStringSync()) as List<dynamic>);

  test('about 30 captions per outcome with unique ids', () {
    for (final o in [Outcome.caught, Outcome.notCaught, Outcome.notFound]) {
      expect(captions.where((c) => c.outcome == o).length, inInclusiveRange(25, 40), reason: o.db);
    }
    expect(captions.map((c) => c.id).toSet().length, captions.length);
    expect(captions.where((c) => !c.id.startsWith('${c.outcome.db}_')).map((c) => c.id), isEmpty);
  });

  test('captions are short enough for the photo column', () {
    expect(captions.where((c) => c.text.replaceAll('{insider}', 'Abcdefgh').length > 80).map((c) => c.id), isEmpty);
  });

  test('no caption mentions any deck word (count only, never which)', () {
    final deck = DeckRepository.parseDeck(jsonDecode(File('assets/decks/words_v1.json').readAsStringSync()) as List<dynamic>);
    var hits = 0;
    for (final c in captions) {
      final text = c.text.toLowerCase();
      for (final w in deck) {
        final word = w.word.toLowerCase();
        if (word.length < 3) continue;
        if (RegExp('(^|[^a-z])${RegExp.escape(word)}([^a-z]|\$)').hasMatch(text)) hits++;
      }
    }
    expect(hits, 0, reason: 'captions that contain a deck word');
  });
}
