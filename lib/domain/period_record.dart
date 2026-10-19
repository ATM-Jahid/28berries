import 'calendar_date.dart';

/// A recorded bleeding interval within a menstrual cycle.
///
/// Both endpoints are inclusive. A missing end means bleeding is ongoing;
/// ending a period does not end its cycle.
final class PeriodRecord {
  factory PeriodRecord({required CalendarDate start, CalendarDate? end}) {
    if (end != null && end.compareTo(start) < 0) {
      throw ArgumentError('Period end must not precede its start.');
    }
    return PeriodRecord._(start, end);
  }

  const PeriodRecord._(this.start, this.end);

  final CalendarDate start;
  final CalendarDate? end;

  bool get isOngoing => end == null;

  /// Inclusive bleeding duration, not cycle length; unknown without an end.
  int? get durationInDays {
    final last = end;
    return last == null ? null : last.differenceInDays(start) + 1;
  }

  /// Whether the intervals share a day, treating an ongoing end as unbounded.
  /// This detects a conflict; it does not assert future bleeding or merge data.
  bool overlaps(PeriodRecord other) {
    final last = end;
    final otherLast = other.end;
    return (last == null || other.start.compareTo(last) <= 0) &&
        (otherLast == null || start.compareTo(otherLast) <= 0);
  }
}
