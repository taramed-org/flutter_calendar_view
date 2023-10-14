import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

/// A utility class for handling booking-related functionality.
class BookingUtil {
  BookingUtil._();

  /// Returns true if the time interval defined by [firstStart] and [firstEnd]
  /// overlaps with the time interval defined by [secondStart] and [secondEnd].
  ///
  /// Two time intervals overlap if there is at least one moment in time that is
  /// included in both intervals.
  ///
  /// Throws an error if any of the required parameters are null.
  ///
  /// Example Usage:
  ///
  /// ```dart
  /// DateTime firstStart = DateTime(2021, 7, 1, 14, 0); // July 1st, 2021, 14:00
  /// DateTime firstEnd = DateTime(2021, 7, 1, 15, 0); // July 1st, 2021, 15:00
  ///
  /// DateTime secondStart = DateTime(2021, 7, 1, 14, 30); // July 1st, 2021, 14:30
  /// DateTime secondEnd = DateTime(2021, 7, 1, 15, 30); // July 1st, 2021, 15:30
  ///
  /// bool isOverlapping = isOverLapping(
  ///  firstStart: firstStart,
  /// firstEnd: firstEnd,
  /// secondStart: secondStart,
  /// secondEnd: secondEnd,
  /// );
  ///
  /// print(isOverlapping); // Output: true
  /// ```
  static bool isOverLapping({
    required DateTime firstStart,
    required DateTime firstEnd,
    required DateTime secondStart,
    required DateTime secondEnd,
  }) {
    return getLatestDateTime(firstStart, secondStart)
        .isBefore(getEarliestDateTime(firstEnd, secondEnd));
  }

  /// Returns the latest [DateTime] between two [DateTime] objects.
  ///
  /// If [first] is after or equal to [second], [first] is returned.
  /// Otherwise, [second] is returned.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// DateTime first = DateTime(2021, 7, 1, 14, 0); // July 1st, 2021, 14:00
  /// DateTime second = DateTime(2021, 7, 1, 15, 0); // July 1st, 2021, 15:00
  /// DateTime latest = getLatestDateTime(first, second);
  /// print(latest); // Output: 2021-07-01 15:00:00.000 or July 1st, 2021, 15:00
  /// ```
  static DateTime getLatestDateTime(DateTime first, DateTime second) {
    return first.isAfterOrEq(second) ? first : second;
  }

  /// Returns the earliest [DateTime] between two given [DateTime]s.
  ///
  /// If [first] is before or equal to [second], [first] is returned.
  /// Otherwise, [second] is returned.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// DateTime first = DateTime(2021, 7, 1, 14, 0); // July 1st, 2021, 14:00
  /// DateTime second = DateTime(2021, 7, 1, 15, 0); // July 1st, 2021, 15:00
  /// DateTime earliest = getEarliestDateTime(first, second);
  /// print(earliest); // Output: 2021-07-01 14:00:00.000 or July 1st, 2021, 14:00
  /// ```
  static DateTime getEarliestDateTime(DateTime first, DateTime second) {
    return first.isBeforeOrEq(second) ? first : second;
  }

  /// Formats the given [dt] DateTime object to a string in the format "HH:mm".
  ///
  /// Returns the formatted string.
  ///
  /// Example:
  /// ```dart
  /// DateTime dt = DateTime.now(); // 2021-07-01 14:30:00.000
  /// String formattedTime = formatTime(dt);
  /// print(formattedTime); // Output: "14:30"
  /// ```
  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }
}
