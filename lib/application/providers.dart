import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/app_database.dart';
import '../data/repositories/content_repositories.dart';
import '../data/repositories/round_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/trip_repository.dart';
import '../domain/engine/stats_calculator.dart';
import '../domain/models/caption.dart';
import '../domain/models/player.dart';
import '../domain/models/round.dart';
import '../domain/models/stats.dart';
import '../domain/models/trip.dart';
import '../domain/models/word.dart';

/// Overridden in main() (and in tests with an in-memory database).
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('databaseProvider must be overridden'));

/// Overridden in main() with the loaded instance.
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'));

final tripRepositoryProvider = Provider((ref) => TripRepository(ref.watch(databaseProvider)));
final roundRepositoryProvider = Provider((ref) => RoundRepository(ref.watch(databaseProvider)));
final settingsRepositoryProvider = Provider((ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)));
final deckRepositoryProvider = Provider((ref) => DeckRepository());
final captionRepositoryProvider = Provider((ref) => CaptionRepository());

final deckProvider = FutureProvider<List<Word>>((ref) => ref.watch(deckRepositoryProvider).load());
final captionsProvider = FutureProvider<List<Caption>>((ref) => ref.watch(captionRepositoryProvider).load());

final openTripProvider = StreamProvider<Trip?>((ref) => ref.watch(tripRepositoryProvider).watchOpenTrip());
final latestTripProvider = StreamProvider<Trip?>((ref) => ref.watch(tripRepositoryProvider).watchLatestTrip());

final tripProvider = StreamProvider.family<Trip?, int>((ref, id) => ref.watch(tripRepositoryProvider).watchTrip(id));

/// All players of a trip (removed ones included), in seat order.
final playersProvider = StreamProvider.family<List<Player>, int>((ref, tripId) => ref.watch(tripRepositoryProvider).watchPlayers(tripId));

final roundRecordsProvider =
    StreamProvider.family<List<RoundRecord>, int>((ref, tripId) => ref.watch(roundRepositoryProvider).watchRecords(tripId));

/// Every stat of a trip, recomputed from saved rounds whenever they change.
final tripStatsProvider = Provider.family<AsyncValue<TripStats>, int>((ref, tripId) {
  final players = ref.watch(playersProvider(tripId));
  final records = ref.watch(roundRecordsProvider(tripId));
  if (players.hasError) return AsyncError(players.error!, players.stackTrace!);
  if (records.hasError) return AsyncError(records.error!, records.stackTrace!);
  if (!players.hasValue || !records.hasValue) return const AsyncLoading();
  return AsyncData(computeStats(players.requireValue, records.requireValue));
});
