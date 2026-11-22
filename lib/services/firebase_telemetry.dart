import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

import '../application/telemetry.dart';
import '../firebase_options.dart';

/// Starts Firebase: Analytics, Crashlytics (with release monitoring) and
/// Performance. Collection is on in release builds only. Returns null if
/// Firebase can't start, so the game still runs.
Future<Telemetry?> initFirebaseTelemetry() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase did not start: $e');
    return null;
  }
  final crashlytics = FirebaseCrashlytics.instance;
  final analytics = FirebaseAnalytics.instance;
  final performance = FirebasePerformance.instance;
  unawaited(crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode));
  unawaited(analytics.setAnalyticsCollectionEnabled(kReleaseMode));
  unawaited(performance.setPerformanceCollectionEnabled(kReleaseMode));

  // Uncaught Flutter and async errors go to Crashlytics.
  FlutterError.onError = crashlytics.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    return true;
  };
  return FirebaseTelemetry(analytics, crashlytics, performance);
}

class FirebaseTelemetry extends Telemetry {
  FirebaseTelemetry(this._analytics, this._crashlytics, this._performance);

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
  final FirebasePerformance _performance;

  /// Fire and forget: diagnostics must never slow down or break the game.
  void _log(String name, Map<String, Object> params) {
    unawaited(_analytics.logEvent(name: name, parameters: params).catchError((Object _) {}));
  }

  @override
  void tripStarted({required int players, required int drivers}) =>
      _log('trip_started', {'players': players, 'drivers': drivers});

  @override
  void roundStarted({required int number, required int players, required bool carMode, required String difficulty}) =>
      _log('round_started', {'round_number': number, 'players': players, 'car_mode': carMode ? 1 : 0, 'difficulty': difficulty});

  @override
  void roundEnded({required String outcome, required int questionsUsed, required int questionLimit, required bool carMode}) =>
      _log('round_ended', {
        'outcome': outcome,
        'questions_used': questionsUsed,
        'question_limit': questionLimit,
        'car_mode': carMode ? 1 : 0,
      });

  @override
  void roundAbandoned({required String phase}) => _log('round_abandoned', {'phase': phase});

  @override
  void tripEnded({required int rounds}) => _log('trip_ended', {'rounds': rounds});

  @override
  void wrappedExported({required String action}) => _log('wrapped_exported', {'action': action});

  @override
  void setRoundPhase(String phase) => unawaited(_crashlytics.setCustomKey('round_phase', phase).catchError((Object _) {}));

  @override
  Future<T> trace<T>(String name, Future<T> Function() body) async {
    final t = _performance.newTrace(name);
    try {
      await t.start();
    } catch (_) {
      return body();
    }
    try {
      return await body();
    } finally {
      unawaited(t.stop().catchError((Object _) {}));
    }
  }
}
