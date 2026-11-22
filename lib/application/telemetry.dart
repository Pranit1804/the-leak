import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Anonymous diagnostics: analytics events, crash context and performance
/// traces. The game never depends on it and plays fully offline.
///
/// Privacy rule: parameters are counts, flags and fixed labels only. Never
/// pass a player name, a trip name, a word or a word id.
abstract class Telemetry {
  const Telemetry();

  /// A new trip was created.
  void tripStarted({required int players, required int drivers});

  /// A round was dealt and the handout began.
  void roundStarted({required int number, required int players, required bool carMode, required String difficulty});

  /// A round reached its reveal. [outcome] is `caught`, `not_caught` or `not_found`.
  void roundEnded({required String outcome, required int questionsUsed, required int questionLimit, required bool carMode});

  /// A round was backed out of. [phase] is the round phase it was in.
  void roundAbandoned({required String phase});

  /// A trip was ended after [rounds] scored rounds.
  void tripEnded({required int rounds});

  /// Trip Wrapped was shared or saved. [action] is `share` or `save`.
  void wrappedExported({required String action});

  /// Crash context: the round phase at the time of a crash.
  void setRoundPhase(String phase);

  /// Times [body] as a performance trace called [name].
  Future<T> trace<T>(String name, Future<T> Function() body);
}

/// Does nothing. Used in tests and whenever Firebase is unavailable.
class NoTelemetry extends Telemetry {
  const NoTelemetry();

  @override
  void tripStarted({required int players, required int drivers}) {}
  @override
  void roundStarted({required int number, required int players, required bool carMode, required String difficulty}) {}
  @override
  void roundEnded({required String outcome, required int questionsUsed, required int questionLimit, required bool carMode}) {}
  @override
  void roundAbandoned({required String phase}) {}
  @override
  void tripEnded({required int rounds}) {}
  @override
  void wrappedExported({required String action}) {}
  @override
  void setRoundPhase(String phase) {}
  @override
  Future<T> trace<T>(String name, Future<T> Function() body) => body();
}

/// Overridden in main() with the Firebase implementation.
final telemetryProvider = Provider<Telemetry>((ref) => const NoTelemetry());
