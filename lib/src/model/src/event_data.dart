// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.
import 'package:calendar_view/src/util/src/extensions.dart';

import 'package:flutter/material.dart';

/// {@template event_type}
/// Defines type of event.
/// {@endtemplate}
enum EventType {
  /// Indicates holiday event.
  holiday(code: 'holiday', name: 'Holiday', color: Colors.lime),

  /// Indicates leave event.
  leave(code: 'leave', name: 'Leave', color: Colors.red),

  /// Indicates birthday event.
  birthday(code: 'birthday', name: 'Birthday', color: Colors.yellowAccent),

  /// Indicates meeting event.
  meeting(code: 'meeting', name: 'Meeting', color: Colors.green),

  /// Indicates travel event.
  travel(code: 'travel', name: 'Travel', color: Colors.purple),

  /// Indicates consultation event.
  consultation(
    code: 'consultation',
    name: 'Consultation',
    color: Colors.orange,
  ),

  /// Indicates others event.
  others(code: 'others', name: 'Others');

  const EventType({
    required this.code,
    required this.name,
    this.color = Colors.blue,
  });

  /// Defines code of event type.
  final String code;

  /// Defines name of event type.
  final String name;

  /// Defines color of event type.
  final Color color;
}

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

  /// The associated event object.
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
    this.eventType = EventType.others,
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

  /// Define event type.
  final EventType eventType;

  /// Returns a Map<String, dynamic> representation of the object.
  Map<String, dynamic> toJson() => {
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'event': event,
        'title': title,
        'description': description,
        'endDate': endDate,
        'type': eventType.code,
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
        description == other.description &&
        eventType == other.eventType;
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
        eventType,
      );
}
