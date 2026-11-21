import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/data/repositories/trip_repository.dart';
import 'package:the_leak/domain/engine/role_assigner.dart';
import 'package:the_leak/presentation/format.dart';
import 'package:the_leak/presentation/screens/round_setup_screen.dart';
import 'package:the_leak/presentation/screens/trip_setup_screen.dart';

List<PlayerDraft> drafts(List<String> names) => [for (final n in names) PlayerDraft(name: n, canDrive: false)];

void main() {
  test('trip setup needs 4 to 8 players with unique names', () {
    expect(playerListProblem(drafts(['A', 'B', 'C'])), contains('one more player'));
    expect(playerListProblem(drafts(['A', 'B', 'C', 'D'])), isNull);
    expect(playerListProblem(drafts(['A', 'B', 'C', 'a'])), contains('Names must be different'));
    expect(playerListProblem(drafts(['1', '2', '3', '4', '5', '6', '7', '8', '9'])), isNotNull);
  });

  test('adding a name: not empty, not a duplicate, at most 8', () {
    expect(addNameProblem('  ', drafts(['A'])), isNotNull);
    expect(addNameProblem('rohan', drafts(['Rohan'])), contains('already'));
    expect(addNameProblem('Z', drafts(['1', '2', '3', '4', '5', '6', '7', '8'])), contains('Up to 8'));
    expect(addNameProblem('Neha', drafts(['Rohan'])), isNull);
  });

  test('every setup problem has a message', () {
    for (final p in SetupProblem.values) {
      expect(setupProblemText(p), isNotEmpty);
    }
  });

  test('formats', () {
    expect(defaultTripName(DateTime(2026, 11, 21)), 'Trip – 21 Nov');
    expect(dateline(DateTime(2026, 11, 20)), 'FRI 20 NOV');
    expect(dateRange(DateTime(2026, 12, 31), DateTime(2027, 1, 11)), '31 DEC – 11 JAN');
    expect(clock(84), '1:24');
    expect(clock(120), '2:00');
  });
}
