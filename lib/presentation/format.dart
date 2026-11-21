const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// "21 Nov"
String shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

/// "FRI 20 NOV" (Reveal dateline)
String dateline(DateTime d) => '${_days[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}'.toUpperCase();

/// "31 DEC – 11 JAN" (Trip Wrapped), or a single date when both match.
String dateRange(DateTime from, DateTime to) {
  final a = shortDate(from).toUpperCase(), b = shortDate(to).toUpperCase();
  return a == b ? a : '$a – $b';
}

/// Default trip name: "Trip – 21 Nov".
String defaultTripName(DateTime now) => 'Trip – ${shortDate(now)}';

/// "2:00", "1:24", "0:05"
String clock(int seconds) {
  final s = seconds < 0 ? 0 : seconds;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}
