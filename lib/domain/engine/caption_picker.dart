import 'dart:math';

import '../models/caption.dart';
import '../models/outcome.dart';

class CaptionPick {
  const CaptionPick({required this.caption, required this.clearedIds});

  final Caption caption;

  /// Caption ids whose "used" mark should be cleared because the pool ran out.
  final Set<String> clearedIds;
}

/// A random caption for [outcome], never repeating within a trip until the
/// pool for that outcome runs out, then starting over.
CaptionPick? pickCaption({
  required List<Caption> pool,
  required Outcome outcome,
  required Set<String> usedIds,
  required Random rng,
}) {
  final forOutcome = pool.where((c) => c.outcome == outcome).toList()..sort((a, b) => a.id.compareTo(b.id));
  if (forOutcome.isEmpty) return null;
  var unused = forOutcome.where((c) => !usedIds.contains(c.id)).toList();
  var cleared = <String>{};
  if (unused.isEmpty) {
    cleared = forOutcome.map((c) => c.id).toSet();
    unused = forOutcome;
  }
  return CaptionPick(caption: unused[rng.nextInt(unused.length)], clearedIds: cleared);
}

/// Fills the `{insider}` placeholder.
String fillCaption(String text, {required String insiderName}) => text.replaceAll('{insider}', insiderName);
