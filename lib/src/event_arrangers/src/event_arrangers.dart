// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

part 'merge_event_arranger.dart';
part 'side_event_arranger.dart';

/// {@template event_arranger}
/// [EventArranger] defines how simultaneous events will be arranged.
/// Implement [arrange] method to define how events will be arranged.
///
/// There are three predefined class that implements of [EventArranger].
///
/// [_StackEventArranger], [SideEventArranger] and [MergeEventArranger].
///
/// [_StackEventArranger] will stack all the events on top of each other.
/// [SideEventArranger] will arrange all the events side by side.
/// [MergeEventArranger] will arrange all the events side by side and will
/// merge the events if they are overlapping.
/// {@endtemplate}
abstract class EventArranger<T extends Object?> {
  /// {@macro event_arranger}
  const EventArranger();

  /// This method will arrange all the events in and return List of
  /// [OrganizedCalendarEventData].
  ///
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  });
}

/// Provides event data with its [left], [right], [top], and [bottom] boundary.
class OrganizedCalendarEventData<T extends Object?> {
  /// Provides event data with its [left], [right], [top], and [bottom]
  /// boundary.
  OrganizedCalendarEventData({
    required this.startDuration,
    required this.endDuration,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.events,
  });

  /// Creates an empty [OrganizedCalendarEventData].
  OrganizedCalendarEventData.empty()
      : startDuration = DateTime.now(),
        endDuration = DateTime.now(),
        right = 0,
        left = 0,
        events = const [],
        top = 0,
        bottom = 0;

  /// Top position from where event tile will start.
  final double top;

  /// End position from where event tile will end.
  final double bottom;

  /// Left position from where event tile will start.
  final double left;

  /// Right position where event tile will end.
  final double right;

  /// List of events to display in given tile.
  final List<CalendarEventData<T>> events;

  /// Start duration of event/event list.
  final DateTime startDuration;

  /// End duration of event/event list.
  final DateTime endDuration;

  /// Returns a new instance of [OrganizedCalendarEventData] with the right
  ///  value updated.
  ///
  /// The [right] parameter is the new value for the right property of the
  ///  returned instance.
  /// The other properties of the returned instance are the same as the
  ///  original instance.
  OrganizedCalendarEventData<T> getWithUpdatedRight(double right) =>
      OrganizedCalendarEventData<T>(
        top: top,
        bottom: bottom,
        endDuration: endDuration,
        events: events,
        left: left,
        right: right,
        startDuration: startDuration,
      );
}
