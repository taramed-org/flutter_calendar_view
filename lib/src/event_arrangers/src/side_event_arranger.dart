// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

/// {@template side_event_arranger}
/// [SideEventArranger] will arrange all the events side by side.
/// {@endtemplate}
class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// {@macro side_event_arranger}
  const SideEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    final mergedEvents = MergeEventArranger<T>().arrange(
      events: events,
      height: height,
      width: width,
      heightPerMinute: heightPerMinute,
    );

    final arrangedEvents = <OrganizedCalendarEventData<T>>[];

    for (final event in mergedEvents) {
      // If there is only one event in list that means, there
      // is no simultaneous events.
      if (event.events.length == 1) {
        arrangedEvents.add(event);
        continue;
      }

      final concurrentEvents = event.events;

      if (concurrentEvents.isEmpty) continue;

      var column = 1;
      final sideEventData = <_SideEventData<T>>[];
      var currentEventIndex = 0;

      while (concurrentEvents.isNotEmpty) {
        final event = concurrentEvents[currentEventIndex];
        final end = event.endTime!.getTotalMinutes == 0
            ? Constants.minutesADay
            : event.endTime!.getTotalMinutes;
        sideEventData.add(_SideEventData(column: column, event: event));
        concurrentEvents.removeAt(currentEventIndex);

        while (currentEventIndex < concurrentEvents.length) {
          if (end <
              concurrentEvents[currentEventIndex].startTime!.getTotalMinutes) {
            break;
          }

          currentEventIndex++;
        }

        if (concurrentEvents.isNotEmpty &&
            currentEventIndex >= concurrentEvents.length) {
          column++;
          currentEventIndex = 0;
        }
      }

      final slotWidth = width / column;

      for (final sideEvent in sideEventData) {
        if (sideEvent.event.startTime == null ||
            sideEvent.event.endTime == null) {
          assert(
            () {
              try {
                debugPrint(
                    'Start time or end time of an event can not be null. '
                    'This ${sideEvent.event} will be ignored.');
              } catch (e) {
                debugPrint('Failed to add event because of $e');
              } // Suppress exceptions.

              return true;
            }(),
            'Can not add event in the list.',
          );

          continue;
        }

        final startTime = sideEvent.event.startTime!;
        final endTime = sideEvent.event.endTime!;
        final bottom = height -
            (endTime.getTotalMinutes == 0
                    ? Constants.minutesADay
                    : endTime.getTotalMinutes) *
                heightPerMinute;
        arrangedEvents.add(
          OrganizedCalendarEventData<T>(
            left: slotWidth * (sideEvent.column - 1),
            right: slotWidth * (column - sideEvent.column),
            top: startTime.getTotalMinutes * heightPerMinute,
            bottom: bottom,
            startDuration: startTime,
            endDuration: endTime,
            events: [sideEvent.event],
          ),
        );
      }
    }

    return arrangedEvents;
  }
}

/// A private class that holds data for a single event in the side event
///  arranger.
class _SideEventData<T> {
  const _SideEventData({
    required this.column,
    required this.event,
  });

  /// The column index where the event should be placed.
  final int column;

  /// The event data to be displayed.
  final CalendarEventData<T> event;
}
