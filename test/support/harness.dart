import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/application/trip_controller.dart';
import 'package:the_leak/data/db/app_database.dart';
import 'package:the_leak/data/repositories/content_repositories.dart';
import 'package:the_leak/data/repositories/trip_repository.dart';
import 'package:the_leak/domain/models/caption.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/word.dart';

/// A deck of placeholder entries; tests never use real deck words.
List<Word> fakeDeck() => [
      for (var i = 1; i <= 30; i++)
        Word(
          id: 'word_${i.toString().padLeft(3, '0')}',
          word: 'word_${i.toString().padLeft(3, '0')}',
          category: DeckCategories.all[i % 8],
          difficulty: Difficulty.values[i % 3],
        ),
    ];

class FakeDeckRepository extends DeckRepository {
  @override
  Future<List<Word>> load() async => fakeDeck();
}

class FakeCaptionRepository extends CaptionRepository {
  @override
  Future<List<Caption>> load() async => [
        for (final o in [Outcome.caught, Outcome.notCaught, Outcome.notFound])
          for (var i = 0; i < 2; i++) Caption(id: '${o.db}_$i', outcome: o, text: '{insider} caption $i'),
      ];
}

/// A mutable clock for tests.
class TestClock {
  DateTime now = DateTime(2026, 11, 20, 10);
  DateTime call() => now;
}

class Harness {
  Harness._(this.db, this.prefs, this.clock, this.container);

  final AppDatabase db;
  final SharedPreferences prefs;
  final TestClock clock;
  final ProviderContainer container;

  static Future<Harness> create({AppDatabase? db, List<Override> extra = const []}) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final database = db ?? AppDatabase(NativeDatabase.memory());
    final clock = TestClock();
    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(database),
      sharedPreferencesProvider.overrideWithValue(prefs),
      deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
      captionRepositoryProvider.overrideWithValue(FakeCaptionRepository()),
      rngProvider.overrideWithValue(Random(1)),
      clockProvider.overrideWithValue(clock.call),
      ...extra,
    ]);
    return Harness._(database, prefs, clock, container);
  }

  T read<T>(ProviderListenable<T> p) => container.read(p);

  /// Creates a trip of [n] players named P1..Pn; P1 can drive.
  Future<int> trip(int n, {Set<int> drivers = const {1}}) => read(tripControllerProvider).createTrip(
        name: 'Test trip',
        players: [for (var i = 1; i <= n; i++) PlayerDraft(name: 'P$i', canDrive: drivers.contains(i))],
      );

  Future<void> dispose() async {
    container.dispose();
    await db.close();
  }
}
