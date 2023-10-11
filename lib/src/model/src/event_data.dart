// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.
import 'package:calendar_view/src/core/src/extensions.dart';

import 'package:flutter/material.dart';

// TODO in future need to investigate if we can delete startTime and endTime

/// {@template event_data}
/// Base class for event data. This class is used to store event data.
/// {@endtemplate}
sealed class EventData<T extends Object?> {
  /// {@macro event_data}
  const EventData({
    required this.date,
    DateTime? endDate,
    this.startTime,
    this.endTime,
    this.event,
  }) : endDate = endDate ?? date;

  /// Defines the date of event.
  final DateTime date;

  /// Defines the end date of the event.
  final DateTime endDate;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [EventData] for `DayView`
  final DateTime? startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [EventData] for `DayView`
  final DateTime? endTime;

  /// Event on [date].
  final T? event;
}

/// {@template calendar_event_data}
/// Defines data for event. This data will be used to display event on calendar.
/// {@endtemplate}
@immutable
class CalendarEventData<T extends Object?> extends EventData<T> {
  /// Stores all the events on [date]
  const CalendarEventData({
    required this.title,
    required super.date,
    this.description,
    this.color = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
    super.event,
    super.startTime,
    super.endTime,
    super.endDate,
  });

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String? description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

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
