import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../domain/engine/round_machine.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/rule_list_row.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/section_header.dart';

/// Who guessed (06): everyone except the Master, the driver tagged DRIVER.
class WhoGuessedScreen extends StatefulWidget {
  const WhoGuessedScreen({super.key, required this.view, required this.onConfirm});

  final RoundView view;
  final ValueChanged<int> onConfirm;

  @override
  State<WhoGuessedScreen> createState() => _WhoGuessedScreenState();
}

class _WhoGuessedScreenState extends State<WhoGuessedScreen> {
  int? _picked;

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final r = v.round;
    final q = r.questionsUsed;
    return PaperScreen(
      body: [
        SectionHeader(left: 'Round ${r.number}', right: 'Cracked in $q ${q == 1 ? 'question' : 'questions'}', rightColor: AppColors.red),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Headline('Who said it?'),
          const SizedBox(height: 6),
          Text('Tap the player who guessed the word.', style: AppText.voice(17)),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Rule.heavy(),
            for (final id in guessCandidates(r))
              RuleListRow(
                key: ValueKey('guesser-$id'),
                title: v.name(id),
                tag: id == r.activeDriverId ? 'DRIVER' : null,
                selection: _picked == id ? RowSelection.ink : RowSelection.none,
                onTap: () => setState(() => _picked = id),
              ),
          ],
        ),
      ],
      bottom: [
        InkButton(
          label: _picked == null ? 'Pick who said it' : '${v.name(_picked)} cracked it',
          onPressed: _picked == null ? null : () => widget.onConfirm(_picked!),
        ),
      ],
    );
  }
}
