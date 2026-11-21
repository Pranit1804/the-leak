class Trip {
  const Trip({
    required this.id,
    required this.name,
    required this.createdAt,
    this.endedAt,
    required this.questionLimit,
    required this.discussionSeconds,
    required this.alertsOn,
    required this.lastCarMode,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? endedAt;
  final int questionLimit;

  /// 0 means the discussion timer is off.
  final int discussionSeconds;
  final bool alertsOn;
  final bool lastCarMode;

  bool get isOpen => endedAt == null;
}

/// Game settings (PRD section 2.4).
class GameSettings {
  const GameSettings({this.questionLimit = 20, this.discussionSeconds = 120, this.alertsOn = true});

  final int questionLimit;
  final int discussionSeconds;
  final bool alertsOn;

  static const questionLimitOptions = [10, 15, 20, 25, 30];
  static const discussionOptions = [0, 60, 120, 180, 240, 300];
  static const minQuestionLimit = 10;
  static const maxQuestionLimit = 30;

  GameSettings copyWith({int? questionLimit, int? discussionSeconds, bool? alertsOn}) => GameSettings(
        questionLimit: questionLimit ?? this.questionLimit,
        discussionSeconds: discussionSeconds ?? this.discussionSeconds,
        alertsOn: alertsOn ?? this.alertsOn,
      );
}
