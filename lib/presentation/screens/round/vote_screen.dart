import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../domain/engine/number_words.dart';
import '../../../domain/engine/round_machine.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/pass_phone_gate.dart';
import '../../widgets/progress_segments.dart';
import '../../widgets/rule_list_row.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/section_header.dart';

/// "Neha, Priya, then Rohan says the vote out loud." / "Then the reveal."
String nextUpText(RoundView v) {
  final order = v.voteOrder;
  final rest = order.sublist((v.round.voteIndex + 1).clamp(0, order.length));
  if (rest.isEmpty) return 'Then the reveal.';
  final driver = v.round.activeDriverId;
  final passengers = rest.where((id) => id != driver).map(v.name).toList();
  if (driver != null && rest.contains(driver)) {
    final d = '${v.name(driver)} says the vote out loud.';
    return passengers.isEmpty ? 'Then $d' : '${passengers.join(', ')}, then $d';
  }
  return '${joinNames(passengers)}.';
}

/// "Priya (Master) and Rohan (driver) aren't suspects, so they're not listed."
String? exclusionText(RoundView v, int voterId) {
  final r = v.round;
  final out = <String>[
    if (r.masterId != voterId) '${v.name(r.masterId)} (Master)',
    if (r.activeDriverId != null && r.activeDriverId != voterId) '${v.name(r.activeDriverId)} (driver)',
  ];
  if (out.isEmpty) return null;
  return out.length == 1 ? "${out.first} isn't a suspect, so isn't listed." : "${joinNames(out)} aren't suspects, so they're not listed.";
}

/// Secret vote (08): a pass gate per passenger, then the candidate list.
/// The Car mode driver goes last: they say the vote and the Master taps it.
class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key, required this.view, required this.onLock});

  final RoundView view;
  final ValueChanged<int> onLock;

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  int? _forIndex;
  bool _unlocked = false;
  int? _pick;

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final r = v.round;
    final order = v.voteOrder;
    final index = r.voteIndex.clamp(0, order.length - 1);
    final voter = order[index];
    if (_forIndex != index) {
      _forIndex = index;
      _unlocked = false;
      _pick = null;
    }
    final isDriver = voter == r.activeDriverId;
    final header = StepHeader(label: 'Secret vote', index: index, total: order.length);
    final name = v.name(voter);

    if (!_unlocked && !isDriver) {
      return PaperScreen(
        key: ValueKey('vote-gate-$index'),
        body: [
          header,
          PassPhoneName(name: name, body: 'Only $name should see the screen. Everyone else, look away.'),
        ],
        bottom: [
          GateButton(label: "I'm $name · tap to vote", onTap: () => setState(() => _unlocked = true)),
          NoteLine(label: 'Next up', labelColor: AppColors.ink, text: nextUpText(v)),
        ],
      );
    }

    final exclusions = exclusionText(v, voter);
    return PaperScreen(
      key: ValueKey('vote-list-$index'),
      body: [
        header,
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('$name, who is the', style: AppText.voice(18)),
          const SizedBox(height: 6),
          const Headline('Leak?', size: 56),
          const SizedBox(height: 6),
          Text(
            isDriver
                ? '$name, say your vote out loud. ${v.name(r.masterId)}, tap the name.'
                : 'Only you can see this. Everyone else, look away.',
            style: AppText.ui(14, color: AppColors.inkMuted),
          ),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Rule.heavy(),
            for (final id in voteCandidates(r, voter))
              RuleListRow(
                key: ValueKey('candidate-$id'),
                title: v.name(id),
                height: 64,
                fontSize: 20,
                selection: _pick == id ? RowSelection.red : RowSelection.none,
                selectedTag: 'YOUR PICK',
                onTap: () => setState(() => _pick = id),
              ),
          ],
        ),
        if (exclusions != null) Text(exclusions, style: AppText.ui(13, color: AppColors.inkMuted, height: 1.5)),
      ],
      bottom: [
        NoteLine(label: 'Next up', labelColor: AppColors.ink, text: nextUpText(v)),
        InkButton(label: 'Lock vote', onPressed: _pick == null ? null : () => widget.onLock(_pick!)),
      ],
    );
  }
}
