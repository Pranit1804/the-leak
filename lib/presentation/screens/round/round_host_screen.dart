import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/router.dart';
import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../../application/settings_controller.dart';
import '../../../application/trip_controller.dart';
import '../../../domain/models/round_phase.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/square_dialog.dart';
import 'discussion_screen.dart';
import 'handout_screen.dart';
import 'reveal_screen.dart';
import 'round_master_screen.dart';
import 'vote_screen.dart';
import 'who_guessed_screen.dart';

/// `/round/:roundId`: renders the screen for the round's stored phase, never
/// navigation history, so a killed app resumes on the exact screen and player.
class RoundHostScreen extends ConsumerStatefulWidget {
  const RoundHostScreen({super.key, required this.roundId});

  final int roundId;

  @override
  ConsumerState<RoundHostScreen> createState() => _RoundHostScreenState();
}

class _RoundHostScreenState extends ConsumerState<RoundHostScreen> {
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _setAwake(true);
  }

  @override
  void dispose() {
    _setAwake(false);
    super.dispose();
  }

  void _setAwake(bool on) {
    // Keep the screen on for the whole round; ignore platforms without it (tests).
    (on ? WakelockPlus.enable() : WakelockPlus.disable()).catchError((Object _) {});
  }

  RoundController get _c => ref.read(roundControllerProvider(widget.roundId).notifier);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('That did not save. Please try again.')));
    }
  }

  Future<void> _back(RoundPhase phase) async {
    switch (phase) {
      case RoundPhase.handout:
        return; // Back is disabled during the handout.
      case RoundPhase.whoGuessed:
        await _guard(_c.backToQuestioning);
        return;
      case RoundPhase.reveal:
      case RoundPhase.done:
        return;
      case RoundPhase.questioning:
      case RoundPhase.discussion:
      case RoundPhase.voting:
        final ok = await confirmSquare(
          context,
          title: 'Abandon round?',
          body: 'Nobody scores and the word is not used again on this trip.',
          confirmLabel: 'Abandon round',
          cancelLabel: 'Keep playing',
          red: true,
        );
        if (!ok || !mounted) return;
        await _guard(_c.abandon);
    }
  }

  void _leave(String location) {
    if (_leaving) return;
    _leaving = true;
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(roundControllerProvider(widget.roundId));
    if (async.hasError && !async.hasValue) {
      return PaperScreen(
        body: [const Headline('Round not found'), Text('This round could not be opened.', style: AppText.ui(15, color: AppColors.inkMuted))],
        bottom: [InkButton(label: 'Home', onPressed: () => context.go(Routes.home))],
      );
    }
    if (!async.hasValue) return const Scaffold(backgroundColor: AppColors.paper);
    final view = async.requireValue;
    final r = view.round;

    if (r.phase == RoundPhase.done) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _leave(view.trip.isOpen ? Routes.newRound(view.trip.id) : Routes.wrapped(view.trip.id));
      });
      return const Scaffold(backgroundColor: AppColors.paper);
    }

    final muted = ref.watch(settingsControllerProvider).muted;
    final Widget screen = switch (r.phase) {
      RoundPhase.handout => HandoutScreen(view: view, onDone: () => _guard(_c.handoutDone)),
      RoundPhase.questioning => RoundMasterScreen(
          view: view,
          muted: muted,
          onToggleMute: () => ref.read(settingsControllerProvider.notifier).setMuted(!muted),
          onIncrement: () {
            HapticFeedback.selectionClick();
            _guard(_c.increment);
          },
          onUndo: () => _guard(_c.undo),
          onWordGuessed: () => _guard(_c.wordGuessed),
          onNotGuessed: () async {
            final ok = await confirmSquare(
              context,
              title: 'Not guessed?',
              body: 'The round ends and the word is revealed. Nobody scores.',
              confirmLabel: 'Reveal the word',
              cancelLabel: 'Keep asking',
            );
            if (ok) await _guard(_c.notGuessed);
          },
        ),
      RoundPhase.whoGuessed => WhoGuessedScreen(view: view, onConfirm: (id) => _guard(() => _c.pickGuesser(id))),
      RoundPhase.discussion => DiscussionScreen(
          view: view,
          now: ref.read(clockProvider),
          onEnd: () => _guard(_c.endDiscussion),
          onThirtySeconds: () => ref.read(roundEventsProvider).discussionEnding(view),
        ),
      RoundPhase.voting => VoteScreen(view: view, onLock: (id) => _guard(() => _c.lockVote(id))),
      RoundPhase.reveal => RevealScreen(
          view: view,
          onNextRound: () => _guard(_c.nextRound),
          onStandings: () => context.push(Routes.standings(view.trip.id)),
          onEndTrip: () async {
            final ok = await confirmSquare(
              context,
              title: 'End ${view.trip.name}?',
              body: 'The trip closes and you get the Trip Wrapped front page.',
              confirmLabel: 'End trip',
            );
            if (ok) await _guard(_c.endTrip);
          },
        ),
      RoundPhase.done => const SizedBox.shrink(),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back(r.phase);
      },
      child: KeyedSubtree(key: ValueKey('phase-${r.phase.name}'), child: screen),
    );
  }
}
