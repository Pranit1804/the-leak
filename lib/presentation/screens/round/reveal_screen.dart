import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../domain/engine/caption_picker.dart';
import '../../../domain/engine/headline_writer.dart';
import '../../../domain/engine/vote_resolver.dart';
import '../../../domain/models/outcome.dart';
import '../../format.dart';
import '../../widgets/halftone.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/newsprint.dart';

/// Reveal (09), the loud tabloid front page.
class RevealScreen extends StatelessWidget {
  const RevealScreen({
    super.key,
    required this.view,
    required this.onNextRound,
    required this.onStandings,
    required this.onEndTrip,
  });

  final RoundView view;
  final VoidCallback onNextRound;
  final VoidCallback onStandings;
  final VoidCallback onEndTrip;

  @override
  Widget build(BuildContext context) {
    final r = view.round;
    final headline = writeHeadline(r, view.votes, names: {for (final p in view.players.values) p.id: p.name}, questionLimit: view.questionLimit);
    final insiderName = view.name(r.insiderId);
    final caption = view.caption == null ? '$insiderName, seconds after the reveal.' : fillCaption(view.caption!.text, insiderName: insiderName);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.paperLoud,
      body: LoudBackground(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18, (media.viewPadding.top + 12).clamp(40, 100), 18, 0),
              sliver: SliverList.list(children: [
                const _Masthead(),
                const SizedBox(height: 3),
                Dateline(left: '${view.trip.name} edition', middle: 'Round ${r.number}', right: dateline(r.startedAt)),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: AppColors.ink,
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    child: Text('EXCLUSIVE', style: AppText.ui(10, weight: 800, letterSpacingEm: 0.2, color: AppColors.loudTop)),
                  ),
                ),
                const SizedBox(height: 10),
                Semantics(
                  header: true,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(headline.title, maxLines: 1, style: AppText.display(104, height: 0.88, letterSpacingEm: -0.01)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(headline.deck, style: AppText.voice(18, height: 1.3)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(top: 2),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.ink), bottom: BorderSide(color: AppColors.ink)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 146,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        const HalftonePhoto(),
                        const SizedBox(height: 5),
                        Text(caption, style: AppText.voice(11, height: 1.3)),
                      ]),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: _VoteColumn(view: view)),
                  ],
                ),
              ]),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 10, 18, 22 + media.viewPadding.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkButton(label: 'Continued in round ${r.number + 1}', fontSize: 22, trailingTriangle: true, onPressed: onNextRound),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: OutlineInkButton(label: 'Standings', height: 46, fontSize: 13, letterSpacingEm: 0.14, onPressed: onStandings)),
                      const SizedBox(width: 10),
                      Expanded(child: OutlineInkButton(label: 'End trip', height: 46, fontSize: 13, letterSpacingEm: 0.14, onPressed: onEndTrip)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead();

  @override
  Widget build(BuildContext context) {
    final small = AppText.ui(9, weight: 800, letterSpacingEm: 0.12, color: AppColors.mastheadSmall, height: 1.2);
    return Container(
      height: 58,
      color: AppColors.red,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Text('LATE\nCITY', style: small),
        Expanded(
          child: Center(child: Text('THE LEAK', style: AppText.display(38, color: AppColors.onInk, letterSpacingEm: 0.04, height: 1.2))),
        ),
        Text('₹2\nONLY', style: small, textAlign: TextAlign.right),
      ]),
    );
  }
}

/// Who the group voted out (red when it was the Leak), then everyone's points:
/// Commons in seat order, then the Master, then the Leak in red.
class _VoteColumn extends StatelessWidget {
  const _VoteColumn({required this.view});

  final RoundView view;

  @override
  Widget build(BuildContext context) {
    final r = view.round;
    final commons = r.participantIds.where((id) => id != r.masterId && id != r.insiderId);
    final rows = [...commons, r.masterId, r.insiderId];
    final group = r.carMode ? 'car' : 'group';
    final out = r.outcome == Outcome.notFound ? null : groupVerdict(view.votes, masterId: r.masterId);
    Widget heading(String text) => Container(
          padding: const EdgeInsets.only(bottom: 3),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: 2))),
          child: Text(text, style: AppText.ui(10, weight: 800, letterSpacingEm: 0.14)),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading(r.outcome == Outcome.notFound ? 'NO VOTE: WORD NOT FOUND' : 'THE ${group.toUpperCase()} VOTED OUT'),
        if (out != null) ...[
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(view.name(out).toUpperCase(),
                style: AppText.display(24, height: 1.1, color: out == r.insiderId ? AppColors.red : AppColors.ink)),
          ),
        ],
        const SizedBox(height: 10),
        heading('POINTS'),
        const SizedBox(height: 4),
        for (var i = 0; i < rows.length; i++) ...[
          _VoteRow(
            left: '${view.name(rows[i])}${rows[i] == r.masterId ? ' (M)' : ''}',
            points: view.points[rows[i]] ?? 0,
            red: rows[i] == r.insiderId,
          ),
          if (i < rows.length - 1) ...[const DottedRule(), const SizedBox(height: 4)],
        ],
        const SizedBox(height: 10),
        Text('THE WORD', style: AppText.ui(10, weight: 800, letterSpacingEm: 0.14)),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(view.word.word.toUpperCase(), style: AppText.display(28, height: 1.1)),
        ),
      ],
    );
  }
}

class _VoteRow extends StatelessWidget {
  const _VoteRow({required this.left, required this.points, required this.red});

  final String left;
  final int points;
  final bool red;

  @override
  Widget build(BuildContext context) {
    final color = red ? AppColors.red : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(left, style: AppText.ui(13, color: color), overflow: TextOverflow.ellipsis)),
        Text(points > 0 ? '+$points' : '$points', style: AppText.ui(13, weight: 800, color: color)),
      ]),
    );
  }
}
