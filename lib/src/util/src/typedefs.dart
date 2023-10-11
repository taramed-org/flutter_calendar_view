// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// ignore_for_file: avoid_positional_boolean_parameters

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// Signature for a function that creates a cell widget for a given date.
///
/// The [date] parameter is the date for which the cell is being built.
///
/// The [event] parameter is a list of [CalendarEventData] objects associated
///  with the date.
///
/// The [isToday] parameter is a boolean value indicating whether the cell
///  represents today's date.
///
/// The [isInMonth] parameter is a boolean value indicating whether the cell
///  represents a date in the current month.
typedef CellBuilder<T extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> event,
  bool isToday,
  bool isInMonth,
);

/// Signature for a function that builds a widget for a single event tile.
///
/// The function takes in the [date] of the tile, a list of [events] on that
///  date,
/// the `boundary` of the tile, the start and end `duration` of the calendar
///  view.
///
/// The generic type [T] represents the type of data associated with the event.
typedef EventTileBuilder<T extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> events,
  Rect boundary,
  DateTime startDuration,
  DateTime endDuration,
);

/// Signature for a function that builds a detector widget for a given date.
///
/// The `date` parameter is the date for which the detector widget is being
///  built.
/// The `height` parameter is the height of the detector widget.
/// The `width` parameter is the width of the detector widget.
/// The `heightPerMinute` parameter is the height of each minute slot in the
///  detector widget.
/// The `minuteSlotSize` parameter is the size of each minute slot in the
///  detector widget.
typedef DetectorBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required double height,
  required double width,
  required double heightPerMinute,
  required MinuteSlotSize minuteSlotSize,
});

/// Signature for a function that builds a widget for a given day of the week.
typedef WeekDayBuilder = Widget Function(
  int day,
);

/// Signature for a function that builds a widget for a given date.
typedef DateWidgetBuilder = Widget Function(
  DateTime date,
);

/// Signature for a function that builds a widget representing the week number
/// for a given [firstDayOfWeek] DateTime.
typedef WeekNumberBuilder = Widget? Function(
  DateTime firstDayOfWeek,
);

/// A function that builds a widget for a full day event.
///
/// The function takes in a list of [CalendarEventData] objects and a
///  [DateTime] object representing the date of the event.
/// It returns a [Widget] object that represents the full day event.
typedef FullDayEventBuilder<T> = Widget Function(
  List<CalendarEventData<T>> events,
  DateTime date,
);

/// Signature for a callback that is called when the calendar page changes.
///
/// The [date] parameter is the new selected date.
/// The [page] parameter is the new selected page.
typedef CalendarPageChangeCallBack = void Function(
  DateTime date,
  int page,
);

/// A function type that takes a [DateTime] and a [CalendarEventData] as
///  arguments
/// and returns nothing.
typedef PageChangeCallback = void Function(
  DateTime date,
  CalendarEventData event,
);

/// A function that takes a [DateTime] and an optional [secondaryDate]
///  and returns a [String].
typedef StringProvider = String Function(
  DateTime date, {
  DateTime? secondaryDate,
});

/// Signature for a function that builds the header of a week page in a
///  calendar view.
///
/// The function takes in a [startDate] and an [endDate] of the week and
///  returns a [Widget].
typedef WeekPageHeaderBuilder = Widget Function(
  DateTime startDate,
  DateTime endDate,
);

/// Signature for a function that is called when a tile is tapped.
///
/// The `event` parameter is the event associated with the tapped tile.
/// The `date` parameter is the date associated with the tapped tile.
typedef TileTapCallback<T extends Object?> = void Function(
  CalendarEventData<T> event,
  DateTime date,
);

/// Signature for a function that will be called when a cell is tapped.
///
/// The function takes a list of [CalendarEventData] objects and a [DateTime]
///  object as input.
/// The [CalendarEventData] objects represent the events associated with the
///  tapped cell.
/// The [DateTime] object represents the date of the tapped cell.
typedef CellTapCallback<T extends Object?> = void Function(
  List<CalendarEventData<T>> events,
  DateTime date,
);

/// Signature for a callback that receives a [DateTime] object representing
///  a date.
typedef DatePressCallback = void Function(DateTime date);

/// A callback function that takes a [DateTime] parameter representing a date.
typedef DateTapCallback = void Function(DateTime date);

/// A function that filters a list of [CalendarEventData] based on a given
///  [date].
///
/// The function takes in a [date] and a list of [events] of type
///  [CalendarEventData<T>].
/// It returns a filtered list of [CalendarEventData<T>] based on the given
///  [date].
typedef EventFilter<T extends Object?> = List<CalendarEventData<T>> Function(
  DateTime date,
  List<CalendarEventData<T>> events,
);
