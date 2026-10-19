/// An immutable Gregorian calendar date, without a time or time zone.
final class CalendarDate implements Comparable<CalendarDate> {
  factory CalendarDate(int year, int month, int day) {
    if (year < 1 || year > 9999 || month < 1 || month > 12) {
      throw ArgumentError('Invalid calendar date.');
    }
    final value = DateTime.utc(year, month, day);
    if (value.year != year || value.month != month || value.day != day) {
      throw ArgumentError('Invalid calendar date.');
    }
    return CalendarDate._(year, month, day);
  }

  const CalendarDate._(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  /// Signed calendar days from [other] to this date.
  int differenceInDays(CalendarDate other) =>
      _utc.difference(other._utc).inDays;

  @override
  int compareTo(CalendarDate other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);
}
