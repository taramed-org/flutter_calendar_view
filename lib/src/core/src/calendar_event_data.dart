// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.
import 'package:calendar_view/src/core/src/extensions.dart';

import 'package:flutter/material.dart';

/// {@template calendar_event_data}
/// Defines data for event. This data will be used to display event on calendar.
/// {@endtemplate}
@immutable
class CalendarEventData<T extends Object?> {
  /// Stores all the events on [date]
  const CalendarEventData({
    required this.title,
    required this.date,
    this.description,
    this.event,
    this.color = Colors.blue,
    this.startTime,
    this.endTime,
    this.titleStyle,
    this.descriptionStyle,
    DateTime? endDate,
  }) : _endDate = endDate;

  /// Defines the date of event.
  final DateTime date;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [CalendarEventData] for `DayView`
  final DateTime? startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [CalendarEventData] for `DayView`
  final DateTime? endTime;

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String? description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Event on [date].
  final T? event;

  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  /// Defines the end date of the event.
  //! It was done intentionally that there is  getter for _endDate because
  //! _endDate could potentially be null. So, we check if _endDate has a value.
  //! If it has a value, we return it. If it doesn't have a value, we return
  //! a default date.

  DateTime get endDate => _endDate ?? date;

  /// Returns a Map<String, dynamic> representation of the object.
  Map<String, dynamic> toJson() => {
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'event': event,
        'title': title,
        'description': description,
        'endDate': endDate,
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        date.compareWithoutTime(other.date) &&
        endDate.compareWithoutTime(other.endDate) &&
        ((event == null && other.event == null) ||
            (event != null && other.event != null && event == other.event)) &&
        ((startTime == null && other.startTime == null) ||
            (startTime != null &&
                other.startTime != null &&
                startTime!.hasSameTimeAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.hasSameTimeAs(other.endTime!))) &&
        title == other.title &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description;
  }

  @override
  int get hashCode => Object.hash(
        date,
        startTime,
        endTime,
        event,
        title,
        description,
        endDate,
        titleStyle,
        descriptionStyle,
        color,
      );
}
