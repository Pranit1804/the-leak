# CLAUDE.md — The Leak

Read this first, then `docs/PRD.md`, `docs/TECH_SPEC.md` and `docs/DESIGN.md`.

## What this is
A single-phone, offline Flutter party game (social deduction, 4–8 players) with a Car mode so the driver can play without touching the screen. Android first.

## Identity
- App name: **The Leak** · Play Store title: "The Leak: Find the Insider" · package: `com.bytecode.theleak`
- Players see the hidden role as "The Leak". In code and docs that role is `insider` (e.g. `insiderId`).

## Hard rules
1. **Sealed word deck.** The developer plays this game too. Never print, list, quote or log any secret word: not in chat, terminal output, commit messages, PR descriptions, test names, test output or debug logs. When you generate `assets/decks/words_v1.json`, report only counts per category and difficulty. Tests assert counts and structure, never specific words.
2. Build the full app milestone by milestone; run flutter analyze and flutter test and make a git commit after each milestone.
3. **Match the design.** Visual source of truth is `design/screens/*.html` plus `docs/DESIGN.md`. Square corners everywhere, the tabloid type system, black primary buttons. Do not invent new colours or rounded cards.
4. **Plays offline.** Every feature works without a connection; no runtime font fetching (fonts are bundled assets). The only network use is Firebase (Analytics, Crashlytics, Performance) sending anonymous diagnostics when online. Never log a player name, trip name, word or word id; all of it goes through `Telemetry` (`lib/application/telemetry.dart`).
5. **Domain layer is pure Dart** with no Flutter imports, and is unit-tested.
6. **Persist before render.** Every round state change is written to the database before the UI updates, so a killed app resumes on the exact screen and player.

## Folder map
- `docs/PRD.md` — product rules, flows, screens, scoring, stats, scope, acceptance criteria
- `docs/TECH_SPEC.md` — architecture, packages, data model, engine, state machine, routing, testing
- `docs/DESIGN.md` — tokens, typography, components, per-screen notes, Flutter theme guidance
- `design/screens/` — 12 static HTML mockups (open in a browser). Secret words are shown as black redaction bars in mockups only; the real app shows the actual word on those spots.
- `design/tokens.json` — colours, type and spacing as data
- `assets/fonts/` — bundled fonts and their OFL licences (see `assets/fonts/README.md`)

## Commands (once the project exists)
- `flutter test` — must pass before any task is called done
- `flutter analyze` — zero warnings
