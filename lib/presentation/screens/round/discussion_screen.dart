import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../format.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/progress_segments.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/section_header.dart';

/// Discussion (07): countdown from the stored end time, so it survives an app kill.
class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({
    super.key,
    required this.view,
    required this.now,
    required this.onEnd,
    this.onThirtySeconds,
  });

  final RoundView view;
  final DateTime Function() now;
  final VoidCallback onEnd;
  final VoidCallback? onThirtySeconds;

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  Timer? _timer;
  bool _ended = false;
  bool _warned = false;

  int get _total => widget.view.trip.discussionSeconds;

  int get _left {
    final ends = widget.view.round.discussionEndsAt;
    if (ends == null) return 0;
    return (ends.difference(widget.now()).inMilliseconds / 1000).ceil().clamp(0, _total);
  }

  @override
  void initState() {
    super.initState();
    // Already past 30 s on resume: don't announce it late.
    _warned = _left <= 30;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    WidgetsBinding.instance.addPostFrameCallback((_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    final left = _left;
    if (!_warned && left <= 30 && left > 0) {
      _warned = true;
      widget.onThirtySeconds?.call();
    }
    if (left <= 0 && !_ended) {
      _ended = true;
      _timer?.cancel();
      widget.onEnd();
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.view;
    final left = _left;
    final group = v.round.carMode ? 'car' : 'group';
    return PaperScreen(
      body: [
        SectionHeader(left: 'Round ${v.round.number}', right: '${v.name(v.round.guessedById)} cracked it', rightColor: AppColors.red),
        const Headline('Find the\nleak', size: 56, height: 0.98, fit: false),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule),
              bottom: BorderSide(color: AppColors.ink, width: AppSpace.lightRule),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(clock(left),
                          key: const Key('discussion-clock'),
                          style: AppText.display(132, height: 0.9).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text('OF ${clock(_total)}', style: AppText.label(color: AppColors.inkMuted)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkProgressBar(fraction: _total == 0 ? 0 : left / _total, semanticLabel: '${clock(left)} left'),
            ],
          ),
        ),
        _Prompts(prompts: ['Who kept steering the questions the right way?', 'Who went quiet once the $group got close?']),
      ],
      bottom: [
        OutlineInkButton(label: 'Skip to the vote', height: 56, style: OutlineStyle.anton, onPressed: _ended ? null : () {
          _ended = true;
          _timer?.cancel();
          widget.onEnd();
        }),
      ],
    );
  }
}

class _Prompts extends StatelessWidget {
  const _Prompts({required this.prompts});

  final List<String> prompts;

  @override
  Widget build(BuildContext context) {
    final style = AppText.voice(17, italic: false, height: 1.4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < prompts.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 22, child: Text('${i + 1}.', style: style)),
            Expanded(child: Text(prompts[i], style: style)),
          ]),
        ],
      ],
    );
  }
}
