import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/providers.dart';
import '../../domain/engine/headline_writer.dart' show headlineTitle;
import '../../domain/models/outcome.dart';
import '../../domain/models/round.dart';
import '../../domain/models/stats.dart';
import '../../domain/models/trip.dart';
import '../stats_text.dart';
import '../widgets/ink_button.dart';
import '../widgets/screen_scaffold.dart';

enum StandingsTab { points, stats, history }

/// Standings (10): Points / Stats / History.
class StandingsScreen extends ConsumerStatefulWidget {
  const StandingsScreen({super.key, required this.tripId});

  final int tripId;

  @override
  ConsumerState<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends ConsumerState<StandingsScreen> {
  StandingsTab _tab = StandingsTab.points;

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider(widget.tripId)).value;
    final stats = ref.watch(tripStatsProvider(widget.tripId));
    final records = ref.watch(roundRecordsProvider(widget.tripId)).value;
    if (trip == null || !stats.hasValue || records == null) return const Scaffold(backgroundColor: AppColors.paper);
    final s = stats.requireValue;
    final rounds = s.roundsPlayed;
    final header = '${trip.name} · $rounds ${rounds == 1 ? 'round' : 'rounds'}${s.days > 0 ? ' · day ${s.days}' : ''}';
    final canWrap = rounds >= wrappedAfterRounds || (!trip.isOpen && rounds > 0);

    return PaperScreen(
      gap: 14,
      body: [
        BackHeader(label: header, onBack: () => context.canPop() ? context.pop() : context.go(Routes.home)),
        const Headline('Standings'),
        _Tabs(selected: _tab, onChanged: (t) => setState(() => _tab = t)),
        ...switch (_tab) {
          StandingsTab.points => _points(s),
          StandingsTab.stats => _stats(s),
          StandingsTab.history => _history(trip, s, records),
        },
      ],
      bottom: [
        if (canWrap) OutlineInkButton(label: 'Trip Wrapped', height: 52, onPressed: () => context.push(Routes.wrapped(trip.id))),
      ],
    );
  }

  List<Widget> _points(TripStats s) {
    final holders = s.awards.where((a) => a.type != AwardType.champion).toList();
    return [
      _PointsTable(stats: s),
      if (holders.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('TITLE HOLDERS SO FAR', style: AppText.label(color: AppColors.red)),
              for (final a in holders) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Text(a.type.title, style: AppText.voice(15, height: 1.2)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: winnersText(a, s), style: AppText.ui(15, weight: 800)),
                        TextSpan(text: ' · ${awardDetail(a, s)}', style: AppText.ui(15)),
                      ]),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      if (s.roundsPlayed == 0) Text('No rounds played yet. Points appear after the first reveal.', style: AppText.ui(14, color: AppColors.inkMuted)),
    ];
  }

  List<Widget> _stats(TripStats s) {
    if (s.roundsPlayed == 0) return [Text('Play a round to see stats.', style: AppText.ui(15, color: AppColors.inkMuted))];
    final rows = s.standings.map((r) => r.stats).toList();
    return [
      for (final line in statLines)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TableHeader(cells: [line.title, line.award.title]),
            for (var i = 0; i < rows.length; i++)
              () {
                // The award holder's row is filled in ink, like the leader on Points.
                final won = s.award(line.award)?.winnerIds.contains(rows[i].player.id) ?? false;
                final c = won ? AppColors.onInk : AppColors.ink;
                return _Row(
                  height: 44,
                  last: i == rows.length - 1,
                  highlight: won,
                  cells: [
                    _Cell(rows[i].player.name, flex: 1, padLeft: won ? 8 : 0, style: AppText.ui(16, weight: won ? 700 : 600, color: c)),
                    _Cell(line.value(rows[i]), align: TextAlign.right, padRight: won ? 8 : 0, style: AppText.ui(16, weight: 700, color: c)),
                  ],
                );
              }(),
            const SizedBox(height: 4),
          ],
        ),
    ];
  }

  List<Widget> _history(Trip trip, TripStats s, List<RoundRecord> records) {
    final played = records.where((r) => r.round.outcome != null && r.round.outcome!.scored).toList();
    if (played.isEmpty) return [Text('No rounds yet.', style: AppText.ui(15, color: AppColors.inkMuted))];
    String name(int id) => s.players[id]?.player.name ?? '';
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TableHeader(cells: ['Rnd', 'The leak', 'Result'], widths: [56, null, null]),
          for (var i = 0; i < played.length; i++)
            _Row(
              height: 52,
              last: i == played.length - 1,
              cells: [
                _Cell('${played[i].round.number}', width: 56, style: AppText.display(20), padLeft: 8),
                _Cell(name(played[i].round.insiderId), flex: 1, style: AppText.ui(17, weight: 600)),
                _Cell(headlineTitle(played[i].round.outcome!).replaceAll('!', ''),
                    align: TextAlign.right,
                    padRight: 8,
                    style: AppText.label(
                        size: 12, color: played[i].round.outcome == Outcome.caught ? AppColors.red : AppColors.ink, letterSpacingEm: 0.14)),
              ],
            ),
        ],
      ),
    ];
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onChanged});

  final StandingsTab selected;
  final ValueChanged<StandingsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: AppSpace.lightRule))),
      child: Row(children: [
        for (final t in StandingsTab.values) ...[
          if (t != StandingsTab.points) const SizedBox(width: 22),
          Semantics(
            button: true,
            selected: t == selected,
            label: t.name,
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(t),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: t == selected ? AppColors.red : Colors.transparent, width: 4)),
                ),
                child: Text(t.name.toUpperCase(),
                    style: AppText.ui(13, weight: t == selected ? 800 : 700, letterSpacingEm: 0.14, color: t == selected ? AppColors.ink : AppColors.inkMuted)),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

class _PointsTable extends StatelessWidget {
  const _PointsTable({required this.stats});

  final TripStats stats;

  @override
  Widget build(BuildContext context) {
    final rows = stats.standings;
    final hasScore = rows.isNotEmpty && rows.first.stats.points > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TableHeader(cells: ['Pos', 'Player', 'Rnd', 'Pts'], widths: [36, null, 48, 56]),
        for (var i = 0; i < rows.length; i++)
          () {
            final leader = hasScore && rows[i].position == 1;
            final c = leader ? AppColors.onInk : AppColors.ink;
            return _Row(
              height: 52,
              last: i == rows.length - 1,
              highlight: leader,
              cells: [
                _Cell('${rows[i].position}', width: 36, style: AppText.display(20, color: c), padLeft: 8),
                _Cell(rows[i].stats.player.name, flex: 1, style: AppText.ui(17, weight: leader ? 700 : 600, color: c)),
                _Cell('${rows[i].stats.roundsPlayed}', width: 48, align: TextAlign.right, style: AppText.ui(17, color: c)),
                _Cell('${rows[i].stats.points}', width: 56, align: TextAlign.right, style: AppText.display(24, color: c), padRight: 8),
              ],
            );
          }(),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.cells, this.widths});

  final List<String> cells;
  final List<double?>? widths;

  @override
  Widget build(BuildContext context) {
    final style = AppText.label(letterSpacingEm: 0.14);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule))),
      child: Row(children: [
        for (var i = 0; i < cells.length; i++)
          () {
            final w = widths == null ? null : widths![i];
            final right = i == cells.length - 1 || (widths != null && i > 1);
            final t = Text(cells[i].toUpperCase(), style: style, textAlign: right ? TextAlign.right : TextAlign.left);
            return w != null ? SizedBox(width: w, child: t) : Expanded(child: t);
          }(),
      ]),
    );
  }
}

class _Cell {
  const _Cell(this.text, {this.width, this.flex, this.align = TextAlign.left, required this.style, this.padLeft = 0, this.padRight = 0});

  final String text;
  final double? width;
  final int? flex;
  final TextAlign align;
  final TextStyle style;
  final double padLeft;
  final double padRight;
}

class _Row extends StatelessWidget {
  const _Row({required this.cells, required this.height, this.highlight = false, this.last = false});

  final List<_Cell> cells;
  final double height;
  final bool highlight;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: highlight ? AppColors.ink : null,
        border: Border(bottom: BorderSide(color: last ? AppColors.ink : AppColors.ruleLight, width: AppSpace.lightRule)),
      ),
      child: Row(children: [
        for (final c in cells)
          () {
            final t = Padding(
              padding: EdgeInsets.only(left: c.padLeft, right: c.padRight),
              child: Text(c.text, style: c.style, textAlign: c.align, maxLines: 1, overflow: TextOverflow.ellipsis),
            );
            if (c.width != null) return SizedBox(width: c.width, child: t);
            return c.flex != null ? Expanded(flex: c.flex!, child: t) : Expanded(child: t);
          }(),
      ]),
    );
  }
}
