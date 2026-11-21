import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/difficulty.dart';
import '../../domain/models/trip.dart';

/// App-wide settings in shared_preferences: game defaults, mute and the last difficulty.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _limit = 'questionLimit';
  static const _discussion = 'discussionSeconds';
  static const _alerts = 'alertsOn';
  static const _muted = 'muted';
  static const _difficulty = 'lastDifficulty';

  GameSettings get game => GameSettings(
        questionLimit: (_prefs.getInt(_limit) ?? 20).clamp(GameSettings.minQuestionLimit, GameSettings.maxQuestionLimit),
        discussionSeconds: (_prefs.getInt(_discussion) ?? 120).clamp(0, 300),
        alertsOn: _prefs.getBool(_alerts) ?? true,
      );

  Future<void> saveGame(GameSettings s) async {
    await _prefs.setInt(_limit, s.questionLimit);
    await _prefs.setInt(_discussion, s.discussionSeconds);
    await _prefs.setBool(_alerts, s.alertsOn);
  }

  bool get muted => _prefs.getBool(_muted) ?? false;

  Future<void> setMuted(bool v) => _prefs.setBool(_muted, v);

  DifficultyChoice get lastDifficulty {
    final name = _prefs.getString(_difficulty);
    return DifficultyChoice.values.firstWhere((d) => d.name == name, orElse: () => DifficultyChoice.medium);
  }

  Future<void> setLastDifficulty(DifficultyChoice d) => _prefs.setString(_difficulty, d.name);
}
