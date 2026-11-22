import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../domain/engine/number_words.dart';
import '../../../domain/engine/round_machine.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/rule_list_row.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/section_header.dart';

/// "Priya (Master) and Rohan (driver) aren't suspects, so they're not listed."
String? exclusionText(RoundView v) {
  final r = v.round;
  final out = <String>[
    '${v.name(r.masterId)} (Master)',
    if (r.activeDriverId != null) '${v.name(r.activeDriverId)} (driver)',
  ];
  return out.length == 1 ? "${out.first} isn't a suspect, so isn't listed." : "${joinNames(out)} aren't suspects, so they're not listed.";
}

/// Group vote (08, as a single group decision): the group agrees on one name
/// and the Master taps it. Nothing secret is on screen.
class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key, required this.view, required this.onVoteOut});

  final RoundView view;
  final ValueChanged<int> onVoteOut;

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  int? _pick;

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final r = v.round;
    final exclusions = exclusionText(v);
    return PaperScreen(
      body: [
        SectionHeader(left: 'Round ${r.number}', right: 'Group vote'),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Agree on one name. Who is the', style: AppText.voice(18)),
          const SizedBox(height: 6),
          const Headline('Leak?', size: 56),
          const SizedBox(height: 6),
          Text('Talk it over, then ${v.name(r.masterId)} taps the name the group picks.',
              style: AppText.ui(14, color: AppColors.inkMuted)),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Rule.heavy(),
            for (final id in voteCandidates(r))
              RuleListRow(
                key: ValueKey('candidate-$id'),
                title: v.name(id),
                height: 64,
                fontSize: 20,
                selection: _pick == id ? RowSelection.red : RowSelection.none,
                selectedTag: 'VOTED OUT',
                onTap: () => setState(() => _pick = id),
              ),
          ],
        ),
        if (exclusions != null) Text(exclusions, style: AppText.ui(13, color: AppColors.inkMuted, height: 1.5)),
      ],
      bottom: [
        InkButton(
          label: _pick == null ? 'Pick one name' : 'Vote out ${v.name(_pick)}',
          onPressed: _pick == null ? null : () => widget.onVoteOut(_pick!),
        ),
      ],
    );
  }
}
