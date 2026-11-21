import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/caption.dart';
import '../../domain/models/difficulty.dart';
import '../../domain/models/outcome.dart';
import '../../domain/models/word.dart';

/// Loads the sealed deck. Never log or print a word.
class DeckRepository {
  DeckRepository({AssetBundle? bundle, this.path = 'assets/decks/words_v1.json'}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String path;
  List<Word>? _cache;

  Future<List<Word>> load() async {
    if (_cache != null) return _cache!;
    final raw = jsonDecode(await _bundle.loadString(path)) as List<dynamic>;
    return _cache = parseDeck(raw);
  }

  static List<Word> parseDeck(List<dynamic> raw) => [
        for (final e in raw.cast<Map<String, dynamic>>())
          Word(
            id: e['id'] as String,
            word: e['word'] as String,
            category: e['category'] as String,
            difficulty: Difficulty.parse(e['difficulty'] as String),
          ),
      ];

  Future<Word?> byId(String id) async {
    for (final w in await load()) {
      if (w.id == id) return w;
    }
    return null;
  }
}

/// Loads the Reveal caption pool.
class CaptionRepository {
  CaptionRepository({AssetBundle? bundle, this.path = 'assets/copy/captions_v1.json'}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String path;
  List<Caption>? _cache;

  Future<List<Caption>> load() async {
    if (_cache != null) return _cache!;
    final raw = jsonDecode(await _bundle.loadString(path)) as List<dynamic>;
    return _cache = parseCaptions(raw);
  }

  static List<Caption> parseCaptions(List<dynamic> raw) => [
        for (final e in raw.cast<Map<String, dynamic>>())
          Caption(id: e['id'] as String, outcome: Outcome.parse(e['outcome'] as String), text: e['text'] as String),
      ];

  Future<Caption?> byId(String id) async {
    for (final c in await load()) {
      if (c.id == id) return c;
    }
    return null;
  }
}
