import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/providers.dart';
import '../../application/trip_controller.dart';
import '../../domain/engine/number_words.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/trip.dart';
import '../widgets/ink_button.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/section_header.dart';
import '../widgets/square_dialog.dart';
import '../widgets/stroke_icon.dart';

/// "Round 12 played. Rohan leads with 18 points."
String tripSummary(TripStats s) {
  if (s.roundsPlayed == 0) return 'No rounds played yet.';
  final played = 'Round ${s.roundsPlayed} played.';
  final leaders = s.standings.where((r) => r.position == 1).toList();
  if (leaders.isEmpty || leaders.first.stats.points == 0) return '$played Nobody has scored yet.';
  final pts = leaders.first.stats.points;
  final unit = pts == 1 ? 'point' : 'points';
  final names = leaders.map((r) => r.stats.player.name).toList();
  return names.length == 1 ? '$played ${names.first} leads with $pts $unit.' : '$played ${joinNames(names)} lead with $pts $unit.';
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(openTripProvider);
    final latest = ref.watch(latestTripProvider);
    if (!open.hasValue || !latest.hasValue) return const Scaffold(backgroundColor: AppColors.paper);
    final openTrip = open.value;
    final latestTrip = latest.value;

    Future<void> newTrip() async {
      if (openTrip != null) {
        final ok = await confirmSquare(
          context,
          title: 'End ${openTrip.name}?',
          body: 'Starting a new trip ends ${openTrip.name}. Its standings stay saved.',
          confirmLabel: 'End and start new',
        );
        if (!ok || !context.mounted) return;
        await ref.read(tripControllerProvider).endTrip(openTrip.id);
        if (!context.mounted) return;
      }
      context.push(Routes.newTrip);
    }

    return PaperScreen(
      gap: 18,
      body: [
        SectionHeader(
          left: 'Party game · 4–8 players',
          trailing: IconSquareButton(icon: AppIcon.settings, semanticLabel: 'Settings', onPressed: () => context.push(Routes.settings)),
        ),
        const _Masthead(),
        if (openTrip != null) _ContinueBlock(trip: openTrip),
        if (latestTrip != null)
          Row(children: [
            Expanded(child: OutlineInkButton(label: 'New trip', onPressed: newTrip)),
            const SizedBox(width: 10),
            Expanded(child: OutlineInkButton(label: 'Standings', onPressed: () => context.push(Routes.standings(latestTrip.id)))),
          ]),
      ],
      bottom: [
        if (latestTrip == null) InkButton(label: 'Start your first trip', onPressed: () => context.push(Routes.newTrip)),
        const NoteLine(label: 'Car mode', text: 'The driver plays every round without touching the screen.', bottomRule: true),
      ],
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text('THE LEAK', style: AppText.display(68, height: 0.95, letterSpacingEm: 0.01))),
          const SizedBox(height: 10),
          Container(height: 8, color: AppColors.red),
          const SizedBox(height: 10),
          Text('One of you already knows the word. Ask, crack it, then catch them.', style: AppText.voice(19)),
        ],
      ),
    );
  }
}

class _ContinueBlock extends ConsumerWidget {
  const _ContinueBlock({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(tripStatsProvider(trip.id));
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.only(top: 14),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('CONTINUE', style: AppText.label(color: AppColors.red)),
          const SizedBox(height: 10),
          Text(trip.name.toUpperCase(), style: AppText.display(36)),
          const SizedBox(height: 10),
          Text(stats.hasValue ? tripSummary(stats.requireValue) : ' ', style: AppText.ui(15, color: AppColors.inkMuted)),
          const SizedBox(height: 16),
          InkButton(
            label: 'Resume trip',
            onPressed: () async {
              final round = await ref.read(roundRepositoryProvider).openRoundOfTrip(trip.id);
              if (!context.mounted) return;
              context.go(round != null ? Routes.round(round.id) : Routes.newRound(trip.id));
            },
          ),
        ],
      ),
    );
  }
}
