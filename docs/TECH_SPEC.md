# The Leak — Technical Spec, v1

A Flutter app that plays fully offline: local database, a pure-Dart game engine, and text-to-speech. No backend. The internet permission exists only for Firebase diagnostics (section 12).

## 1. Architecture
Four layers, each depending only on the one below it:
1. **Presentation** — screens and widgets. No game logic.
2. **Application** — Riverpod notifiers (`TripController`, `RoundController`, `SettingsController`) that call the engine and repositories.
3. **Domain** — pure Dart models and the game engine. No Flutter imports. Fully unit-tested.
4. **Data** — drift database, repositories, deck and caption loaders.

## 2. Folder structure
```text
lib/
  main.dart
  app/            router.dart, theme.dart (built from docs/DESIGN.md)
  domain/
    models/       trip, player, round, vote, word, role, round_phase, outcome
    engine/       role_assigner, word_picker, vote_resolver, scorer, stats_calculator, headline_writer
  data/
    db/           app_database.dart, tables.dart, daos/
    repositories/ trip_repository, round_repository, deck_repository, caption_repository
  application/    trip_controller, round_controller, settings_controller
  services/       announcer.dart, announcer_lines.dart, haptics.dart, share_card.dart
  presentation/
    screens/      home, trip_setup, round_setup, handout, round, who_guessed, discussion, vote, reveal, standings, wrapped
    widgets/      pass_phone_gate, hold_to_reveal, big_counter, section_header, ink_button, rule_list_row, segmented_square, square_toggle, progress_segments
assets/
  fonts/          Anton, LibreFranklin, LibreCaslonText (bundled .ttf, OFL)
  decks/          words_v1.json (sealed, generated)
  copy/           captions_v1.json
test/
  domain/         engine + stats tests
  widgets/        hold_to_reveal, big_counter
```

## 3. Packages
| Need | Package |
|---|---|
| State management | `flutter_riverpod` |
| Routing | `go_router` |
| Local database | `drift` + `sqlite3_flutter_libs` (+ `drift_dev`, `build_runner` as dev deps) |
| App settings (mute, alerts) | `shared_preferences` |
| Spoken announcements | `flutter_tts` |
| Keep screen on during a round | `wakelock_plus` |
| Share Trip Wrapped card | `share_plus` + `RepaintBoundary` → PNG |
| Save card to gallery | `gal` |
| Diagnostics | `firebase_core`, `firebase_analytics`, `firebase_crashlytics`, `firebase_performance` (project `the-leak-app`) |
| Haptics | `HapticFeedback` (Flutter SDK) |

Fonts are declared in `pubspec.yaml` from `assets/fonts/`. Do **not** use runtime font fetching (the app is offline).

## 4. Data model (drift)
| Table | Fields |
|---|---|
| Trip | id, name, createdAt, endedAt?, questionLimit, discussionSeconds, alertsOn, lastCarMode |
| Player | id, tripId, name, seatOrder, canDrive, removedAt? |
| Round | id, tripId, number, startedAt, endedAt?, carMode, driverId? (null when Car mode is off), masterId, insiderId, wordId, captionId?, phase, handoutIndex, voteIndex, questionsUsed, outcome (`caught` / `not_caught` / `not_found` / `abandoned`), guessedById? |
| Vote | id, roundId, voterId, targetId — one row per round: the group's pick, entered by the Master (`voterId` = `masterId`). Rounds saved by older builds may hold one row per player. |
| RoundScore | roundId, playerId, points |
| UsedWord | tripId, wordId |
| UsedCaption | tripId, captionId |

## 5. Game engine (pure Dart, unit-tested)
- `assignRoles(players, carMode, driverId, previousInsiderId, previousMasterId, rng)` → Master and Insider, following PRD 2.1.
- `pickWord(difficulty, usedWordIds, rng)` → an unused word; when a difficulty runs out, reshuffle and flag it once.
- `resolveVote(votes, insiderId)` → caught when the group voted out the Insider. `groupVerdict(votes)` → who was voted out (for older per-player votes: the clear top target, none on a tie).
- `scoreRound(round, votes)` → points per player from the PRD scoring table.
- `computeStats(trip)` → every stat on demand from rounds and votes; nothing stored twice.
- `writeHeadline(round, votes)` → headline + deck sentence for the Reveal screen.
- Every function that randomises takes a `Random` so tests can seed it.

## 6. Round state machine
A round is always in exactly one phase, stored in `Round.phase`. The screen shown is decided by the phase, never by navigation history.

| Phase | Entered when | Screen | Moves to |
|---|---|---|---|
| `handout` | Start round tapped | Role handout | `questioning` after the last player hides their card |
| `questioning` | Handout finished | Round (Master) | `whoGuessed` on Word guessed; `reveal` on Not guessed |
| `whoGuessed` | Word guessed tapped | Who guessed | `discussion`, or `voting` if the timer is off |
| `discussion` | Guesser picked | Discussion | `voting` at zero or on Skip |
| `voting` | Discussion ended | Vote | `reveal` once the group vote is saved |
| `reveal` | Group vote saved, or word not found | Reveal | `done` on Next round or End trip |
| `done` | Round closed | — | — |

- A confirmed back-out from any phase sets outcome `abandoned` and phase `done`; nothing is scored.
- `RoundController` writes phase, `handoutIndex`, `voteIndex` and `questionsUsed` to the database **before** updating UI state.

## 7. Routing (`go_router`)
| Route | Screen |
|---|---|
| `/` | Home |
| `/trip/new` | Trip setup |
| `/trip/:tripId/round/new` | Round setup |
| `/round/:roundId` | Renders the screen for the round's current phase |
| `/trip/:tripId/standings` | Standings |
| `/trip/:tripId/wrapped` | Trip Wrapped |

On launch, if any round is not `done`, open `/round/:roundId` directly.

## 8. Announcer service
- Wraps `flutter_tts`: language `en-IN`, falling back to `en-GB` then `en-US`; `awaitSpeakCompletion(true)`.
- Queues lines so two announcements never overlap; respects the mute setting.
- Methods: `roundStarted`, `questionsLeft(n)`, `wordGuessed(name)`, `discussionEnding`, `voteStarted`, `reveal(result)`, `dailyStandings`.
- All spoken text lives in `announcer_lines.dart`, ready for other languages later.

## 9. Hold-to-reveal and privacy
- Role and word content renders only while a pointer is down on the reveal control (`Listener` / `GestureDetector` with `onTapDown` / `onTapUp` / `onTapCancel`). On release or cancel, hide immediately.
- Hide on app pause (`AppLifecycleState.paused`) as well.
- Role handout: every card shows for a fixed 4 seconds and then closes by itself, even while held, so the Leak's reading time can't give them away.
- Mark the role handout and Round (Master, for the peek) screens with `FLAG_SECURE` on Android so screenshots and the recent-apps preview don't leak roles.

## 10. Reliability
- Save round state after every tap (counter, votes, indexes).
- Minimum 4 players; in Car mode at least 3 non-driving players so a Master, an Insider and one non-driving Common exist.
- Target Android 8+, works on a 3 GB RAM phone, app size under 25 MB.

## 11. Testing
- **Engine:** 1,000 seeded rounds of `assignRoles` confirm the Car mode driver is never Master or Insider, no Insider repeats two rounds running, and the Master rotates in seat order. `resolveVote` and `groupVerdict` cover the group vote and older per-player votes. `scoreRound` covers every row of the scoring table.
- **Stats:** a fixture trip of 12 hand-scored rounds; every stat must match the hand count.
- **Deck:** counts per category and difficulty, unique IDs, valid fields, no duplicate words. Never print or assert a specific word.
- **Widgets:** hold-to-reveal hides the instant the finger lifts and, on the handout, closes by itself after 4 seconds; counter stops at the limit; Undo stops at 0.
- **Manual:** announcements over car Bluetooth, a full trip in airplane mode, kill the app in every phase and reopen.


## 12. Telemetry (Firebase)
- Firebase project `the-leak-app`; config in `lib/firebase_options.dart` and `android/app/google-services.json` (generated by `flutterfire configure`).
- `Telemetry` (`lib/application/telemetry.dart`) is the only way the app reports anything; `FirebaseTelemetry` implements it, `NoTelemetry` is the default in tests. Collection is on in release builds only.
- No advertising ID: the `AD_ID` permission that Analytics brings in is removed in the manifest, and ad-ID collection and ad personalisation signals are off.
- Analytics events: `trip_started` (players, drivers), `round_started` (round_number, players, car_mode, difficulty), `round_ended` (outcome, questions_used, question_limit, car_mode), `round_abandoned` (phase), `trip_ended` (rounds), `wrapped_exported` (action). Parameters are counts, flags and fixed labels only: never a player name, trip name, word or word id (`test/application/telemetry_test.dart` checks this).
- Crashlytics: uncaught Flutter and async errors, plus a `round_phase` custom key. Release monitoring needs Google Analytics linked to the project.
- Performance: automatic app-start and screen traces, plus a `start_round` custom trace.
