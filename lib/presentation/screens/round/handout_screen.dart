import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../domain/models/role.dart';
import '../../widgets/hold_to_reveal.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/pass_phone_gate.dart';
import '../../widgets/progress_segments.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/section_header.dart';
import 'role_copy.dart';

/// Role handout (04a pass the phone / 04b role revealed while held).
class HandoutScreen extends StatefulWidget {
  const HandoutScreen({super.key, required this.view, required this.onDone});

  final RoundView view;
  final Future<void> Function() onDone;

  @override
  State<HandoutScreen> createState() => _HandoutScreenState();
}

/// Every player's card shows for exactly this long, then closes by itself, so
/// the Leak (and the Master) take no longer than a Common who has no word.
const handoutRevealDuration = Duration(seconds: 4);

class _HandoutScreenState extends State<HandoutScreen> {
  bool _seen = false;
  bool _liftedEarly = false;
  int? _seenIndex;

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final order = v.handoutOrder;
    final index = v.round.handoutIndex.clamp(0, order.length - 1);
    final playerId = order[index];
    if (_seenIndex != index) {
      _seen = false;
      _liftedEarly = false;
      _seenIndex = index;
    }
    final name = v.name(playerId);
    final isLast = index == order.length - 1;
    final doneLabel = isLast ? 'Done · start round' : 'Done · pass to ${v.name(order[index + 1])}';
    final driver = v.round.activeDriverId;
    final role = playerId == v.round.masterId
        ? Role.master
        : playerId == v.round.insiderId
            ? Role.insider
            : Role.common;

    return HoldToReveal(
      key: ValueKey('handout-$index'),
      maxDuration: handoutRevealDuration,
      onHidden: (completed) => setState(() {
        if (completed) {
          _seen = true;
        } else if (!_seen) {
          _liftedEarly = true;
        }
      }),
      builder: (context, revealed, holdTarget) {
        final header = StepHeader(label: 'Role handout', index: index, total: order.length);
        final done = InkButton(label: doneLabel, onPressed: widget.onDone);
        if (revealed) {
          return PaperScreen(
            body: [
              header,
              Padding(padding: const EdgeInsets.only(top: 16), child: Text('$name, you are', style: AppText.voice(20))),
              RoleCard(role: role, carMode: v.round.carMode, word: role == Role.common ? null : v.word.word),
              _ScoringLine(copy: RoleCopy.of(role, carMode: v.round.carMode)),
            ],
            bottom: [
              Center(child: Text('THE CARD CLOSES BY ITSELF', style: AppText.label(color: AppColors.inkMuted))),
              const _CountdownBar(duration: handoutRevealDuration),
            ],
          );
        }
        return PaperScreen(
          body: [
            header,
            PassPhoneName(name: name, body: 'Only $name should see the screen. Everyone else, look away.'),
          ],
          bottom: [
            if (_liftedEarly && !_seen)
              Center(
                child: Text('Keep holding until the card closes by itself.',
                    style: AppText.ui(14, weight: 600)),
              ),
            holdTarget(GateButton(label: _seen ? 'Hold to see again' : "I'm $name · hold to see")),
            if (_seen) done,
            if (driver != null) NoteLine(label: 'Driver', text: '${v.name(driver)} is skipped and plays as a Common.'),
          ],
        );
      },
    );
  }
}

/// The 12 px progress bar, emptying over [duration] while the card is shown.
class _CountdownBar extends StatelessWidget {
  const _CountdownBar({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: 0),
        duration: duration,
        builder: (context, value, _) => InkProgressBar(fraction: value),
      );
}

class _ScoringLine extends StatelessWidget {
  const _ScoringLine({required this.copy});

  final RoleCopy copy;

  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(children: [
        TextSpan(text: copy.scoringLead, style: AppText.ui(14, weight: 800, height: 1.5)),
        TextSpan(text: copy.scoring, style: AppText.ui(14, color: AppColors.inkMuted, height: 1.5)),
      ]));
}

/// The role card: 3 px ink border, red "TOP SECRET" strip, role name in Anton
/// 62 (the Leak in red), job, and the word for the Master and the Leak.
class RoleCard extends StatelessWidget {
  const RoleCard({super.key, required this.role, required this.carMode, this.word});

  final Role role;
  final bool carMode;
  final String? word;

  @override
  Widget build(BuildContext context) {
    final copy = RoleCopy.of(role, carMode: carMode);
    return Container(
      decoration: BoxDecoration(color: AppColors.paperRaised, border: Border.all(color: AppColors.ink, width: AppSpace.heavyRule)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Text('TOP SECRET · FOR YOUR EYES ONLY', style: AppText.label(color: AppColors.onInk, letterSpacingEm: 0.2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(copy.title,
                      style: AppText.display(62, height: 0.95, color: role == Role.insider ? AppColors.red : AppColors.ink)),
                ),
                const SizedBox(height: 14),
                Text(copy.job, style: AppText.voice(17, italic: false, height: 1.45)),
                if (word != null) ...[
                  const SizedBox(height: 14),
                  const Rule.ink(),
                  const SizedBox(height: 14),
                  Text('SECRET WORD', style: AppText.label()),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(word!.toUpperCase(), style: AppText.display(44, height: 1.05)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
