import 'calendar_date.dart';
import 'period_record.dart';

/// An observed cycle whose next period start is an exclusive boundary.
final class MenstrualCycle {
  const MenstrualCycle._(this.period, this.nextPeriodStart);

  final PeriodRecord period;
  final CalendarDate? nextPeriodStart;

  CalendarDate get start => period.start;
  bool get isOngoing => nextPeriodStart == null;

  /// Start-to-start calendar days, or unknown for the latest cycle.
  int? get lengthInDays => nextPeriodStart?.differenceInDays(start);

  /// Derives chronological cycles from one profile's records without mutation.
  /// Conflicting periods must be resolved first. Missing periods are not inferred.
  static List<MenstrualCycle> fromPeriods(Iterable<PeriodRecord> periods) {
    final ordered = periods.toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    for (var i = 1; i < ordered.length; i++) {
      if (ordered[i - 1].overlaps(ordered[i])) {
        throw ArgumentError(
          'Resolve conflicting periods before deriving cycles.',
        );
      }
    }
    return List<MenstrualCycle>.unmodifiable([
      for (var i = 0; i < ordered.length; i++)
        MenstrualCycle._(
          ordered[i],
          i + 1 < ordered.length ? ordered[i + 1].start : null,
        ),
    ]);
  }
}
