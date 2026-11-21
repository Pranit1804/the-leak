import 'outcome.dart';

/// A Reveal photo caption. [text] may contain `{insider}` for the Insider's name.
class Caption {
  const Caption({required this.id, required this.outcome, required this.text});

  final String id;
  final Outcome outcome;
  final String text;
}
