import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/trip.dart';
import 'providers.dart';

class AppSettings {
  const AppSettings({required this.game, required this.muted});

  final GameSettings game;
  final bool muted;

  AppSettings copyWith({GameSettings? game, bool? muted}) => AppSettings(game: game ?? this.game, muted: muted ?? this.muted);
}

/// Global settings. Game settings are copied into a new trip, and edits also
/// update the open trip so they apply from its next round.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return AppSettings(game: repo.game, muted: repo.muted);
  }

  Future<void> updateGame(GameSettings game) async {
    await ref.read(settingsRepositoryProvider).saveGame(game);
    final open = await ref.read(tripRepositoryProvider).openTrip();
    if (open != null) await ref.read(tripRepositoryProvider).applySettings(open.id, game);
    state = state.copyWith(game: game);
  }

  Future<void> setQuestionLimit(int v) => updateGame(state.game.copyWith(questionLimit: v));
  Future<void> setDiscussionSeconds(int v) => updateGame(state.game.copyWith(discussionSeconds: v));
  Future<void> setAlertsOn(bool v) => updateGame(state.game.copyWith(alertsOn: v));

  Future<void> setMuted(bool v) async {
    await ref.read(settingsRepositoryProvider).setMuted(v);
    state = state.copyWith(muted: v);
  }
}

final settingsControllerProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
