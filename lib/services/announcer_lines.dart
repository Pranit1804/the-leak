/// Every spoken line (PRD section 4), kept in one place for other languages later.
///
/// Never put a role or the word in a line that is spoken before the reveal.
abstract final class AnnouncerLines {
  static const _ones = [
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', //
    'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen',
  ];
  static const _tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

  /// Spoken form of 0–99 ("twenty-five").
  static String spoken(int n) {
    if (n < 0 || n > 99) return '$n';
    if (n < 20) return _ones[n];
    final t = _tens[n ~/ 10];
    return n % 10 == 0 ? t : '$t-${_ones[n % 10]}';
  }

  static String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String roundStarted(int number, String master) => 'Round $number. $master is the Master. Start asking.';

  /// "Ten questions left." / "Five questions left." / "Last question."
  static String questionsLeft(int n) => n == 1 ? 'Last question.' : '${_cap(spoken(n))} questions left.';

  /// "Word guessed by Rohan! Two minutes to find the leak."
  static String wordGuessed(String name, int discussionSeconds) {
    if (discussionSeconds <= 0) return 'Word guessed by $name!';
    final minutes = discussionSeconds ~/ 60;
    final span = discussionSeconds % 60 == 0
        ? (minutes == 1 ? 'One minute' : '${_cap(spoken(minutes))} minutes')
        : '${_cap(spoken(discussionSeconds))} seconds';
    return 'Word guessed by $name! $span to find the leak.';
  }

  static const discussionEnding = 'Thirty seconds.';

  /// The group agrees on one name and the Master taps it.
  static const voteStarted = 'Time to vote. Agree on one name to vote out.';

  static String revealCaught(String insider, String word) => 'The leak was $insider. Caught! The word was $word.';

  static String revealNotCaught(String insider, String word) =>
      'The leak was $insider, and nobody caught them. The word was $word.';

  static String revealNotFound(String insider, String word, {required bool outOfQuestions}) => outOfQuestions
      ? 'Out of questions. The word was $word, and the leak was $insider.'
      : 'Word not found. The word was $word, and the leak was $insider.';

  /// "Day 4. Rohan leads with 18 points, Priya is second with 15."
  ///
  /// [leaders] share first place with [leaderPoints]; [seconds] share second
  /// place with [secondPoints] (empty when the lead is shared).
  static String dailyStandings(int day, {required List<String> leaders, required int leaderPoints, List<String> seconds = const [], int secondPoints = 0}) {
    if (leaders.isEmpty || leaderPoints == 0) return 'Day $day. Nobody has scored yet.';
    final pts = leaderPoints == 1 ? 'point' : 'points';
    final lead = leaders.length == 1
        ? '${leaders.first} leads with $leaderPoints $pts'
        : '${_join(leaders)} are joint leaders with $leaderPoints $pts';
    if (leaders.length > 1 || seconds.isEmpty || secondPoints == 0) return 'Day $day. $lead.';
    final second = seconds.length == 1 ? '${seconds.first} is second with $secondPoints' : '${_join(seconds)} are joint second with $secondPoints';
    return 'Day $day. $lead, $second.';
  }

  static const testVoice = 'This is The Leak. Announcements will sound like this.';

  static String _join(List<String> names) =>
      names.length == 1 ? names.first : '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}';
}
