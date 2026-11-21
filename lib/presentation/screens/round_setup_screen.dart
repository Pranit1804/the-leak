import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/providers.dart';
import '../../application/trip_controller.dart';
import '../../domain/engine/role_assigner.dart';
import '../../domain/engine/word_picker.dart';
import '../../domain/models/difficulty.dart';
import '../../domain/models/player.dart';
import '../../domain/models/round.dart';
import '../../domain/models/trip.dart';
import '../widgets/ink_button.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/section_header.dart';
import '../widgets/segmented_square.dart';
import '../widgets/square_toggle.dart';

String setupProblemText(SetupProblem p) => switch (p) {
      SetupProblem.tooFewPlayers => 'You need at least $minPlayers players. Tap Edit players to add more.',
      SetupProblem.tooManyPlayers => 'Up to $maxPlayers players can play. Tap Edit players to remove some.',
      SetupProblem.noDriverChosen || SetupProblem.driverNotEligible => "Pick who's driving now.",
      SetupProblem.tooFewPassengers => 'Car mode needs at least $minNonDrivingPlayers players who are not driving.',
    };

/// Round setup (03): round number, Master preview, Car mode, driver, difficulty.
class RoundSetupScreen extends ConsumerStatefulWidget {
  const RoundSetupScreen({super.key, required this.tripId});

  final int tripId;

  @override
  ConsumerState<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends ConsumerState<RoundSetupScreen> {
  bool? _carMode;
  int? _driverId;
  DifficultyChoice? _difficulty;
  bool _starting = false;

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider(widget.tripId));
    final players = ref.watch(playersProvider(widget.tripId));
    final records = ref.watch(roundRecordsProvider(widget.tripId));
    if (!trip.hasValue || !players.hasValue || !records.hasValue) return const Scaffold(backgroundColor: AppColors.paper);
    final t = trip.value;
    if (t == null) return const Scaffold(backgroundColor: AppColors.paper);
    return _build(context, t, players.requireValue, records.requireValue);
  }

  Widget _build(BuildContext context, Trip trip, List<Player> all, List<RoundRecord> records) {
    final active = activeInSeatOrder(all);
    final drivers = active.where((p) => p.canDrive).toList();
    final last = records.isEmpty ? null : records.last.round;
    final canCar = drivers.isNotEmpty;

    final carMode = canCar && (_carMode ?? trip.lastCarMode);
    var driverId = _driverId;
    if (driverId == null || !drivers.any((d) => d.id == driverId)) {
      final lastDriver = last?.driverId;
      driverId = drivers.any((d) => d.id == lastDriver) ? lastDriver : (drivers.isEmpty ? null : drivers.first.id);
    }
    final difficulty = _difficulty ?? ref.read(settingsRepositoryProvider).lastDifficulty;

    final problems = checkRoundSetup(all, carMode: carMode, driverId: driverId);
    final eligible = eligiblePlayers(all, carMode: carMode, driverId: driverId);
    final masterId = eligible.isEmpty
        ? null
        : nextMaster(all, carMode: carMode, driverId: carMode ? driverId : null, previousMasterId: last?.masterId);
    String nameOf(int? id) => all.firstWhere((p) => p.id == id, orElse: () => active.first).name;

    final number = nextRoundNumber(records.map((r) => r.round.outcome));
    final deck = ref.watch(deckProvider).value;
    final used = ref.watch(usedWordIdsProvider(trip.id)).value;
    final runOut = deck != null && used != null && remainingWords(deck, difficulty, used) == 0;

    final note = problems.isNotEmpty
        ? setupProblemText(problems.first)
        : carMode
            ? '${eligible.length} passengers get roles. ${nameOf(driverId)} is driving, so plays as a Common.'
            : 'All ${active.length} players get roles.';

    Future<void> start() async {
      if (_starting || problems.isNotEmpty) return;
      setState(() => _starting = true);
      try {
        final id = await ref.read(tripControllerProvider).startRound(
              tripId: trip.id,
              carMode: carMode,
              driverId: carMode ? driverId : null,
              difficulty: difficulty,
            );
        if (context.mounted) context.go(Routes.round(id));
      } finally {
        if (mounted) setState(() => _starting = false);
      }
    }

    return PaperScreen(
      body: [
        BackHeader(
          label: trip.name,
          onBack: () => context.go(Routes.home),
          trailing: TextInkButton(label: 'Edit players', onPressed: () => context.go(Routes.editTrip(trip.id))),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Headline('Round $number'),
            const SizedBox(height: 6),
            Text(masterId == null ? 'Add players to pick a Master.' : '${nameOf(masterId)} is the Master this round.',
                style: AppText.voice(17)),
          ],
        ),
        ToggleRow(
          title: 'Car mode',
          subtitle: canCar ? 'The driver plays without the screen' : 'Tick who drives in Edit players to use it',
          value: carMode,
          onChanged: canCar ? (v) => setState(() => _carMode = v) : null,
        ),
        if (carMode)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("WHO'S DRIVING NOW?", style: AppText.label()),
              const SizedBox(height: 10),
              ChoiceGrid<int>(
                options: drivers.map((d) => d.id).toList(),
                selected: driverId,
                labelOf: nameOf,
                onChanged: (id) => setState(() => _driverId = id),
              ),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('DIFFICULTY', style: AppText.label()),
            const SizedBox(height: 10),
            SegmentedSquare<DifficultyChoice>(
              options: DifficultyChoice.values,
              selected: difficulty,
              labelOf: (d) => d.label,
              onChanged: (d) => setState(() => _difficulty = d),
            ),
          ],
        ),
        NoteLine(label: 'Note', text: note, inline: true),
        if (runOut)
          NoteLine(
            label: 'Note',
            text: 'Every ${difficulty == DifficultyChoice.mixed ? '' : '${difficulty.label.toLowerCase()} '}word has been played on this trip, so the deck will be reshuffled.',
            inline: true,
          ),
      ],
      bottom: [
        InkButton(label: 'Start round', onPressed: problems.isEmpty && !_starting ? start : null),
      ],
    );
  }
}
