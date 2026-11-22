import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/providers.dart';
import '../../application/telemetry.dart';
import '../../domain/models/round.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/trip.dart';
import '../../services/share_card.dart';
import '../format.dart';
import '../stats_text.dart';
import '../widgets/halftone.dart';
import '../widgets/ink_button.dart';
import '../widgets/newsprint.dart';

/// Trip Wrapped (11): the shareable "CASE CLOSED" special edition.
class WrappedScreen extends ConsumerStatefulWidget {
  const WrappedScreen({super.key, required this.tripId});

  final int tripId;

  @override
  ConsumerState<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends ConsumerState<WrappedScreen> {
  final _cardKey = GlobalKey();
  bool _busy = false;
  bool _saved = false;

  Future<void> _share(Trip trip) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await shareCard(await capturePng(_cardKey), tripName: trip.name);
      ref.read(telemetryProvider).wrappedExported(action: 'share');
    } catch (_) {
      _snack('Could not open sharing. Try Save instead.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save(Trip trip) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final ok = await saveCardToGallery(await capturePng(_cardKey), tripName: trip.name);
      if (!ok) {
        _snack('Allow photo access to save the front page.');
      } else if (mounted) {
        ref.read(telemetryProvider).wrappedExported(action: 'save');
        setState(() => _saved = true);
      }
    } catch (_) {
      _snack('Could not save the image.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider(widget.tripId)).value;
    final stats = ref.watch(tripStatsProvider(widget.tripId));
    final records = ref.watch(roundRecordsProvider(widget.tripId)).value;
    if (trip == null || !stats.hasValue || records == null) return const Scaffold(backgroundColor: AppColors.desk);
    final media = MediaQuery.of(context);

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.desk,
        body: Padding(
          padding: EdgeInsets.fromLTRB(24, (media.viewPadding.top + 12).clamp(40, 100), 24, 24 + media.viewPadding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('YOUR TRIP, ON THE FRONT PAGE', style: AppText.label(color: AppColors.deskLabel)),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Color(0x80000000), offset: Offset(0, 14), blurRadius: 30)]),
                      child: RepaintBoundary(
                        key: _cardKey,
                        child: WrappedCard(trip: trip, stats: stats.requireValue, records: records),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: InkButton.highlight(label: 'Share image', fontSize: 20, onPressed: _busy ? null : () => _share(trip))),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlineInkButton(
                    label: _saved ? 'Saved' : 'Save',
                    height: 56,
                    style: OutlineStyle.anton,
                    fontSize: 20,
                    color: AppColors.paper,
                    onPressed: _busy ? null : () => _save(trip),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

/// The 342 × 608 front-page card, also rendered to the shared PNG.
class WrappedCard extends StatelessWidget {
  const WrappedCard({super.key, required this.trip, required this.stats, required this.records});

  final Trip trip;
  final TripStats stats;
  final List<RoundRecord> records;

  @override
  Widget build(BuildContext context) {
    final played = records.where((r) => r.round.outcome?.scored ?? false).toList();
    final from = played.isEmpty ? trip.createdAt : played.first.round.startedAt;
    final to = trip.endedAt ?? (played.isEmpty ? trip.createdAt : played.last.round.startedAt);
    final champ = stats.award(AwardType.champion);
    final awards = stats.awards.where((a) => a.type != AwardType.champion).toList();

    return SizedBox(
      width: 342,
      height: 608,
      child: Stack(children: [
        Positioned.fill(child: Container(color: AppColors.paper)),
        const Positioned.fill(child: CustomPaint(painter: HalftonePainter())),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 44,
                color: AppColors.red,
                alignment: Alignment.center,
                child: Text('THE LEAK', style: AppText.display(28, color: AppColors.onInk, letterSpacingEm: 0.06, height: 1.2)),
              ),
              const SizedBox(height: 10),
              Dateline(left: 'Special edition', middle: trip.name, right: dateRange(from, to), fontSize: 9, weight: 800),
              const SizedBox(height: 14),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text('CASE CLOSED', style: AppText.display(62, height: 0.92)),
              ),
              const SizedBox(height: 10),
              Text(wrappedDeck(stats), style: AppText.voice(15, height: 1.35)),
              const SizedBox(height: 10),
              Container(
                color: AppColors.ink,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('CHAMPION', style: AppText.ui(9, weight: 800, letterSpacingEm: 0.2, color: AppColors.paper)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(champ == null ? '—' : winnersText(champ, stats).toUpperCase(),
                            style: AppText.display(30, color: AppColors.onInk)),
                      ),
                    ]),
                  ),
                  if (champ != null)
                    Text.rich(TextSpan(children: [
                      TextSpan(text: '${stats.players[champ.winnerIds.first]!.points} ', style: AppText.display(34, color: AppColors.onInk)),
                      TextSpan(text: 'PTS', style: AppText.display(16, color: AppColors.onInk)),
                    ])),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(bottom: 3),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: 2))),
                child: Text('THE AWARDS', style: AppText.ui(10, weight: 800, letterSpacingEm: 0.16)),
              ),
              const SizedBox(height: 6),
              if (awards.isEmpty) Text('No titles won yet.', style: AppText.voice(14)),
              for (var i = 0; i < awards.length; i++) ...[
                Row(children: [
                  Text(awards[i].type.title,
                      style: AppText.voice(14, height: 1.2, color: awards[i].type == AwardType.alwaysSuspected ? AppColors.red : AppColors.ink)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(winnersText(awards[i], stats),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.ui(14, weight: 700, color: awards[i].type == AwardType.alwaysSuspected ? AppColors.red : AppColors.ink)),
                  ),
                ]),
                const SizedBox(height: 4),
                if (i < awards.length - 1) ...[const DottedRule(), const SizedBox(height: 6)],
              ],
              const Spacer(),
              Center(child: Text('PRINTED BY THE LEAK', style: AppText.ui(9, weight: 800, letterSpacingEm: 0.2, color: AppColors.inkMuted))),
            ],
          ),
        ),
      ]),
    );
  }
}
