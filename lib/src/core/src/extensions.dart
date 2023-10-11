// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// Returns the given object of type T.
///
/// This function is used to make the type of an object ambiguous.
/// It can be useful in cases where the type of an object is inferred
/// incorrectly by the Dart compiler.
///
/// Example:
/// ```
/// String? name = "John";
/// var ambiguousName = ambiguate(name);
/// ```
/// In the above example, the type of `ambiguousName` is inferred as `String?`.
///
/// Params:
/// - `object`: The object of type T to be returned.
///
/// Returns:
/// - The given object of type T.
T? ambiguate<T>(T? object) => object;

/// Extension on [DateTime] functions.
extension DateTimeExtensions on DateTime {
  /// Compares only [day], [month] and [year] of [DateTime].
  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  /// Gets difference of months between [date] and calling object.
  int getMonthDifference(DateTime date) {
    if (year == date.year) return (date.month - month).abs() + 1;

    var months = ((date.year - year).abs() - 1) * 12;

    if (date.year >= year) {
      months += date.month + (13 - month);
    } else {
      months += month + (13 - date.month);
    }

    return months;
  }

  /// Gets difference of days between [date] and calling object.
  int getDayDifference(DateTime date) => DateTime.utc(year, month, day)
      .difference(DateTime.utc(date.year, date.month, date.day))
      .inDays
      .abs();

  /// Gets difference of weeks between [date] and calling object.
  int getWeekDifference(DateTime date, {WeekDays start = WeekDays.monday}) =>
      (firstDayOfWeek(start: start)
                  .difference(date.firstDayOfWeek(start: start))
                  .inDays
                  .abs() /
              7)
          .ceil();

  /// Returns The List of date of Current Week, all of the dates will be without
  /// time.
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  /// ``` dart
  /// final now = DateTime.now();
  ///final weekDates = now.datesOfWeek();
  /// print(weekDates);
  ///  // [2022-01-10 00:00:00.000, 2022-01-11 00:00:00.000, 2022-01-12 00:00:00.000, 2022-01-13 00:00:00.000, 2022-01-14 00:00:00.000, 2022-01-15 00:00:00.000, 2022-01-16 00:00:00.000]
  /// // It will read as [Jan 10, Mon], [Jan 11, Tue], [Jan 12, Wed], [Jan 13, Thu], [Jan 14, Fri], [Jan 15, Sat], [Jan 16, Sun]
  /// ```
  List<DateTime> datesOfWeek({WeekDays start = WeekDays.monday}) {
    // Here %7 ensure that we do not subtract >6 and <0 days.
    // Initial formula is,
    //    difference = (weekday - startInt)%7
    // where weekday and startInt ranges from 1 to 7.
    // But in WeekDays enum index ranges from 0 to 6 so we are
    // adding 1 in index. So, new formula with WeekDays is,
    //    difference = (weekdays - (start.index + 1))%7
    //
    final startDay =
        DateTime(year, month, day - (weekday - start.index - 1) % 7);

    return [
      startDay,
      DateTime(startDay.year, startDay.month, startDay.day + 1),
      DateTime(startDay.year, startDay.month, startDay.day + 2),
      DateTime(startDay.year, startDay.month, startDay.day + 3),
      DateTime(startDay.year, startDay.month, startDay.day + 4),
      DateTime(startDay.year, startDay.month, startDay.day + 5),
      DateTime(startDay.year, startDay.month, startDay.day + 6),
    ];
  }

  /// Returns the first date of week containing the current date
  DateTime firstDayOfWeek({WeekDays start = WeekDays.monday}) =>
      DateTime(year, month, day - ((weekday - start.index - 1) % 7));

  /// Returns the last date of week containing the current date
  DateTime lastDayOfWeek({WeekDays start = WeekDays.monday}) =>
      DateTime(year, month, day + (6 - (weekday - start.index - 1) % 7));

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month
  /// can have.
  List<DateTime> datesOfMonths({WeekDays startDay = WeekDays.monday}) {
    final monthDays = <DateTime>[];
    for (var i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays
          .addAll(DateTime(year, month, start).datesOfWeek(start: startDay));
    }
    return monthDays;
  }

  /// Gives formatted date in form of 'month - year'.
  String get formatted => '$month-$year';

  /// Returns total minutes this date is pointing at.
  /// if [DateTime] object is, DateTime(2021, 5, 13, 12, 4, 5)
  /// Then this getter will return 12*60 + 4 which evaluates to 724.
  int get getTotalMinutes => hour * 60 + minute;

  /// Returns a new [DateTime] object with hour and minutes calculated from
  /// [totalMinutes].
  ///
  /// Example usage:
  /// ```dart
  /// final now = DateTime.now(); // 2021-05-13 12:04:05.123456
  /// final newDate = now.copyFromMinutes(1000); // 2021-05-13 16:40:05.123456
  /// ```
  DateTime copyFromMinutes([int totalMinutes = 0]) => DateTime(
        year,
        month,
        day,
        totalMinutes ~/ 60,
        totalMinutes % 60,
      );

  /// Returns [DateTime] without timestamp.
  DateTime get withoutTime => DateTime(year, month, day);

  /// Compares time of two [DateTime] objects.
  bool hasSameTimeAs(DateTime other) {
    return other.hour == hour &&
        other.minute == minute &&
        other.second == second &&
        other.millisecond == millisecond &&
        other.microsecond == microsecond;
  }

  /// Returns true if [DateTime] is start of day.
  bool get isDayStart => hour % 24 == 0 && minute % 60 == 0;

  // @Deprecated(
  //     'This extension is not being used in this package and will be removed '
  //     'in next major release. Please use withoutTime instead.')
  // DateTime get dateYMD => DateTime(year, month, day);
}

/// Extension on [Color] functions.
extension ColorExtension on Color {
  /// Returns the opposite color of the given color.
  Color get accent =>
      (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
          ? Colors.black
          : Colors.white;
}

// /// Extension on [MaterialColor] functions.
// extension MaterialColorExtension on MaterialColor {
//   @Deprecated(
//       'This extension is not being used in this package and will be removed '
//       'in next major release.')
//   Color get accent =>
//       (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
//           ? Colors.black
//           : Colors.white;
// }

/// Extension on [List] functions with type [CalendarEventData].
extension XCalendarEventDataList on List<CalendarEventData> {
  /// Adds the given [event] to the list in a sorted manner based on the start
  ///  time of the events.
  /// If the start time of the given [event] is less than or equal to the start
  ///  time of an event in the list,
  /// the [event] is inserted before that event. Otherwise, the [event] is
  ///  added to the end of the list.
  void insertAscending(CalendarEventData event) {
    var addIndex = -1;
    for (var i = 0; i < length; i++) {
      if (event.startTime!.compareTo(this[i].startTime!) <= 0) {
        addIndex = i;
        break;
      }
    }

    if (addIndex > -1) {
      insert(addIndex, event);
    } else {
      add(event);
    }
  }

  /// Inserts the given [event] in descending order based on its start time.
  /// If the start time of the given [event] is greater than or equal to the
  ///  start time of an existing event,
  /// the [event] is inserted before that existing event.
  /// Otherwise, the [event] is added to the end of the list.
  void insertDescending(CalendarEventData event) {
    var addIndex = -1;
    for (var i = 0; i < length; i++) {
      if (event.startTime!.compareTo(this[i].startTime!) >= 0) {
        addIndex = i;
        break;
      }
    }

    if (addIndex > -1) {
      insert(addIndex, event);
    } else {
      add(event);
    }
  }

  /// Inserts the given [event] into the list in either ascending or descending
  ///  order based on the value of [asc].
  /// If [asc] is true, the event is inserted in ascending order. Otherwise,
  ///  it is inserted in descending order.
  void insertOrder({required CalendarEventData event, bool asc = true}) {
    if (asc) {
      insertAscending(event);
    } else {
      insertDescending(event);
    }
  }
}
