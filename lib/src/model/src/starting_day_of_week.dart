import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

/// Enum for the starting day of the week.
enum StartingDayOfWeek {
  /// Monday
  monday,

  /// Tuesday
  tuesday,

  /// Wednesday
  wednesday,

  /// Thursday
  thursday,

  /// Friday
  friday,

  /// Saturday
  saturday,

  /// Sunday
  sunday,
}

/// Extending the enum of [StartingDayOfWeek]
extension StartingDayOfWeekX on StartingDayOfWeek {
  /// Convert [StartingDayOfWeek] to [tc.StartingDayOfWeek]
  tc.StartingDayOfWeek toTC() => switch (this) {
        StartingDayOfWeek.monday => tc.StartingDayOfWeek.monday,
        StartingDayOfWeek.tuesday => tc.StartingDayOfWeek.tuesday,
        StartingDayOfWeek.wednesday => tc.StartingDayOfWeek.wednesday,
        StartingDayOfWeek.thursday => tc.StartingDayOfWeek.thursday,
        StartingDayOfWeek.friday => tc.StartingDayOfWeek.friday,
        StartingDayOfWeek.saturday => tc.StartingDayOfWeek.saturday,
        StartingDayOfWeek.sunday => tc.StartingDayOfWeek.sunday,
      };
}
