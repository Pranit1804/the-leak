# The Leak

An offline, single-phone social deduction party game for 4–8 players, with a Car mode so the driver can play without touching the screen. Flutter, Android first.

Start with `CLAUDE.md`, then the specs in `docs/` and the mockups in `design/screens/`.

## Run it

```sh
flutter pub get
flutter run                      # on a connected Android phone or emulator
```

## Check it

```sh
flutter analyze                  # must report no issues
flutter test                     # engine, stats, data, widgets and a 10-round UI flow
```

## Build a release

```sh
flutter build appbundle --release      # for the Play Store (per-device downloads of about 18–21 MB)
flutter build apk --release --split-per-abi
```

Release builds are still signed with the debug key (`android/app/build.gradle.kts`). Add a real signing config before uploading to Play.

## After changing the database tables

```sh
dart run build_runner build
```

## The sealed deck

`assets/decks/words_v1.json` holds the secret words. Don't open it if you want to play. Git is set never to diff it (`.gitattributes`), and its tests only check counts and structure.
