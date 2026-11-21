const _words = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];

/// Numbers under ten as words, otherwise digits (PRD section 3.1).
String numberWord(int n) => n >= 0 && n < 10 ? _words[n] : '$n';

/// Same as [numberWord] with the first letter capitalised.
String numberWordCap(int n) {
  final w = numberWord(n);
  return w[0].toUpperCase() + w.substring(1);
}

/// "one question" / "seven questions" / "12 questions".
String questionsPhrase(int n) => n == 1 ? 'one question' : '${numberWord(n)} questions';

/// Joins names: "A", "A and B", "A, B and C".
String joinNames(List<String> names) {
  if (names.isEmpty) return '';
  if (names.length == 1) return names.first;
  return '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}';
}
