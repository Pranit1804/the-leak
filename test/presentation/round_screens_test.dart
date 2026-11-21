import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/app/theme.dart';
import 'package:the_leak/application/round_controller.dart';
import 'package:the_leak/domain/models/caption.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/player.dart';
import 'package:the_leak/domain/models/round.dart';
import 'package:the_leak/domain/models/round_phase.dart';
import 'package:the_leak/domain/models/trip.dart';
import 'package:the_leak/domain/models/vote.dart';
import 'package:the_leak/domain/models/word.dart';
import 'package:the_leak/presentation/screens/round/discussion_screen.dart';
import 'package:the_leak/presentation/screens/round/handout_screen.dart';
import 'package:the_leak/presentation/screens/round/reveal_screen.dart';
import 'package:the_leak/presentation/screens/round/round_master_screen.dart';
import 'package:the_leak/presentation/screens/round/vote_screen.dart';
import 'package:the_leak/presentation/screens/round/who_guessed_screen.dart';

const names = ['Rohan', 'Priya', 'Amit', 'Sneha', 'Kunal', 'Neha'];
const dummyWord = 'word_001';

RoundView mockupView({RoundPhase phase = RoundPhase.handout, int handout = 0, int vote = 0, Outcome? outcome, int? guessed}) {
  final players = {for (var i = 0; i < names.length; i++) i + 1: Player(id: i + 1, name: names[i], seatOrder: i, canDrive: i == 0 || i == 2)};
  final now = DateTime(2026, 11, 20, 12);
  return RoundView(
    round: Round(
      id: 1,
      tripId: 1,
      number: 13,
      startedAt: now,
      carMode: true,
      driverId: 1,
      masterId: 2,
      insiderId: 4,
      wordId: 'food_001',
      phase: phase,
      handoutIndex: handout,
      voteIndex: vote,
      questionsUsed: 7,
      guessedById: guessed,
      outcome: outcome,
      discussionEndsAt: now.add(const Duration(seconds: 84)),
      participantIds: const [1, 2, 3, 4, 5, 6],
    ),
    trip: Trip(id: 1, name: 'South Trip', createdAt: now, questionLimit: 20, discussionSeconds: 120, alertsOn: true, lastCarMode: true),
    players: players,
    word: const Word(id: 'food_001', word: dummyWord, category: 'food', difficulty: Difficulty.easy),
    votes: const [
      Vote(voterId: 3, targetId: 4),
      Vote(voterId: 4, targetId: 6),
      Vote(voterId: 5, targetId: 4),
      Vote(voterId: 6, targetId: 3),
      Vote(voterId: 2, targetId: 4),
      Vote(voterId: 1, targetId: 4),
    ],
    caption: const Caption(id: 'c1', outcome: Outcome.caught, text: '{insider}, seconds after the reveal.'),
    points: const {1: 2, 2: 1, 3: 2, 4: 0, 5: 2, 6: 2},
  );
}

Future<void> pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: child));
  await tester.pump();
}

void main() {
  testWidgets('handout: the word shows only while held and hides the instant the finger lifts', (tester) async {
    final v = mockupView(handout: 1); // Sneha, the Leak, 2 of 5
    var done = 0;
    await pumpScreen(tester, HandoutScreen(view: v, onDone: () async => done++));
    expect(find.text('2 OF 5'), findsOneWidget);
    expect(find.text('SNEHA'), findsOneWidget);
    expect(find.textContaining('Rohan is skipped'), findsOneWidget);
    expect(find.text(dummyWord.toUpperCase()), findsNothing);
    expect(find.textContaining('DONE'), findsNothing);

    final gesture = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
    await tester.pump();
    expect(find.text('THE LEAK'), findsOneWidget);
    expect(find.text(dummyWord.toUpperCase()), findsOneWidget);
    expect(find.text('DONE · PASS TO KUNAL'), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsNothing, reason: 'hidden on release');
    expect(find.text('THE LEAK'), findsNothing);
    await tester.tap(find.text('DONE · PASS TO KUNAL'));
    expect(done, 1);
  });

  testWidgets('handout: a cancelled pointer and app pause also hide the card', (tester) async {
    await pumpScreen(tester, HandoutScreen(view: mockupView(handout: 1), onDone: () async {}));
    final g = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsOneWidget);
    await g.cancel();
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsNothing);

    final g2 = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await g2.up();
  });

  testWidgets('handout: a Common sees no word; the Master is last', (tester) async {
    await pumpScreen(tester, HandoutScreen(view: mockupView(handout: 0), onDone: () async {}));
    final g = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
    await tester.pump();
    expect(find.text('COMMON'), findsOneWidget);
    expect(find.text('SECRET WORD'), findsNothing);
    await g.up();
    await pumpScreen(tester, HandoutScreen(view: mockupView(handout: 4), onDone: () async {}));
    expect(find.text('PRIYA'), findsOneWidget);
    final g2 = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
    await tester.pump();
    expect(find.text('THE MASTER'), findsOneWidget);
    expect(find.text('DONE · START ROUND'), findsOneWidget);
    await g2.up();
  });

  testWidgets('round master: counter, peek while held, buttons', (tester) async {
    var plus = 0;
    await pumpScreen(
      tester,
      RoundMasterScreen(
        view: mockupView(phase: RoundPhase.questioning),
        muted: false,
        onToggleMute: () {},
        onIncrement: () => plus++,
        onUndo: () {},
        onWordGuessed: () {},
        onNotGuessed: () {},
      ),
    );
    expect(find.text('7'), findsOneWidget);
    expect(find.text('/ 20'), findsOneWidget);
    expect(find.text('13 questions left'), findsOneWidget);
    expect(find.text('Master: Priya'), findsOneWidget);
    await tester.tap(find.text('+1'));
    expect(plus, 1);
    expect(find.text(dummyWord.toUpperCase()), findsNothing);
    final g = await tester.startGesture(tester.getCenter(find.bySemanticsLabel('Hold to peek at the word')));
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsOneWidget);
    await g.up();
    await tester.pump();
    expect(find.text(dummyWord.toUpperCase()), findsNothing);
  });

  testWidgets('who guessed lists everyone but the Master, driver tagged', (tester) async {
    int? picked;
    await pumpScreen(tester, WhoGuessedScreen(view: mockupView(phase: RoundPhase.whoGuessed), onConfirm: (id) => picked = id));
    expect(find.text('CRACKED IN 7 QUESTIONS'), findsOneWidget);
    expect(find.text('Priya'), findsNothing);
    expect(find.text('DRIVER'), findsOneWidget);
    await tester.tap(find.text('Amit'));
    await tester.pump();
    await tester.tap(find.text('AMIT CRACKED IT'));
    expect(picked, 3);
  });

  testWidgets('discussion shows the countdown', (tester) async {
    final v = mockupView(phase: RoundPhase.discussion, guessed: 3);
    await pumpScreen(tester, DiscussionScreen(view: v, now: () => DateTime(2026, 11, 20, 12), onEnd: () {}));
    expect(find.text('1:24'), findsOneWidget);
    expect(find.text('OF 2:00'), findsOneWidget);
    expect(find.text('AMIT CRACKED IT'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('vote: gate, then candidates without self, Master and driver', (tester) async {
    int? locked;
    await pumpScreen(tester, VoteScreen(view: mockupView(phase: RoundPhase.voting, vote: 2), onLock: (id) => locked = id));
    expect(find.text('3 OF 6'), findsOneWidget);
    expect(find.text('KUNAL'), findsOneWidget);
    await tester.tap(find.textContaining('TAP TO VOTE'));
    await tester.pump();
    expect(find.text('Kunal, who is the'), findsOneWidget);
    for (final n in ['Amit', 'Sneha', 'Neha']) {
      expect(find.text(n), findsOneWidget);
    }
    for (final n in ['Kunal', 'Priya', 'Rohan']) {
      expect(find.text(n), findsNothing);
    }
    expect(find.text('Neha, Priya, then Rohan says the vote out loud.'), findsOneWidget);
    await tester.tap(find.text('Sneha'));
    await tester.pump();
    expect(find.text('YOUR PICK'), findsOneWidget);
    await tester.tap(find.text('LOCK VOTE'));
    expect(locked, 4);
  });

  testWidgets('vote: the driver step has no gate', (tester) async {
    await pumpScreen(tester, VoteScreen(view: mockupView(phase: RoundPhase.voting, vote: 5), onLock: (_) {}));
    expect(find.text('Rohan, who is the'), findsOneWidget);
    expect(find.textContaining('say your vote out loud'), findsOneWidget);
  });

  testWidgets('reveal: caught front page', (tester) async {
    await pumpScreen(
      tester,
      RevealScreen(
        view: mockupView(phase: RoundPhase.reveal, outcome: Outcome.caught, guessed: 3),
        onNextRound: () {},
        onStandings: () {},
        onEndTrip: () {},
      ),
    );
    expect(find.text('CAUGHT!'), findsOneWidget);
    expect(find.text('SOUTH TRIP EDITION'), findsOneWidget);
    expect(find.text('FRI 20 NOV'), findsOneWidget);
    expect(find.textContaining('exposed as the leak in a 4–2 vote'), findsOneWidget);
    expect(find.text('Priya (M) → Sneha'), findsOneWidget);
    expect(find.text('Sneha → Neha'), findsOneWidget);
    expect(find.text('CONTINUED IN ROUND 14'), findsOneWidget);
    expect(find.text('HOW THE CAR VOTED'), findsOneWidget);
  });

  testWidgets('reveal: not found and escaped render', (tester) async {
    final nf = mockupView(phase: RoundPhase.reveal, outcome: Outcome.notFound);
    await pumpScreen(tester, RevealScreen(view: nf.copyWith(votes: const [], points: const {}), onNextRound: () {}, onStandings: () {}, onEndTrip: () {}));
    expect(find.text('NOT FOUND'), findsOneWidget);
    await pumpScreen(
      tester,
      RevealScreen(view: mockupView(phase: RoundPhase.reveal, outcome: Outcome.notCaught, guessed: 3), onNextRound: () {}, onStandings: () {}, onEndTrip: () {}),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('small phone (360 × 640) still lays out every screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final w in <Widget>[
      HandoutScreen(view: mockupView(handout: 1), onDone: () async {}),
      RoundMasterScreen(
          view: mockupView(phase: RoundPhase.questioning),
          muted: true,
          onToggleMute: () {},
          onIncrement: () {},
          onUndo: () {},
          onWordGuessed: () {},
          onNotGuessed: () {}),
      VoteScreen(view: mockupView(phase: RoundPhase.voting, vote: 2), onLock: (_) {}),
      RevealScreen(view: mockupView(phase: RoundPhase.reveal, outcome: Outcome.caught, guessed: 3), onNextRound: () {}, onStandings: () {}, onEndTrip: () {}),
    ]) {
      await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: w));
      expect(tester.takeException(), isNull);
    }
  });
}
