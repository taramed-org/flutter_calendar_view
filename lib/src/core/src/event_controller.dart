// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template event_controller}
/// Calendar controller to control all the events related operations like,
/// adding event, removing event, etc.
/// {@endtemplate}
class EventController<T extends Object?> extends ChangeNotifier {
  /// {@macro event_controller}
  EventController({
    /// This method will provide list of events on particular date.
    ///
    /// This method is use full when you have recurring events.
    /// As of now this library does not support recurring events.
    /// You can implement same behaviour in this function.
    /// This function will overwrite default behaviour of [getEventsOnDay]
    /// function which will be used to display events on given day in
    /// [MonthView], [DayView] and [WeekView].
    ///
    EventFilter<T>? eventFilter,
  }) : _eventFilter = eventFilter;

  /// The filter used to determine which events should be displayed.
  EventFilter<T>? _eventFilter;

  // Store all calendar event data
  final CalendarData<T> _calendarData = CalendarData();

  //#endregion

  //#region Public Fields

  //! Note: Do not use this getter inside of EventController class.
  //! use _eventList instead.
  ///! Returns list of [CalendarEventData<T>] stored in this controller.
  UnmodifiableListView<CalendarEventData<T>> get events =>
      UnmodifiableListView(_calendarData.events.toList(growable: false));

  /// Returns the event filter function used to filter events for a specific
  ///  date.
  ///
  /// This method is useful when dealing with recurring events, which are not
  ///  currently supported by this library.
  /// You can implement the desired behavior for recurring events in this
  ///  function.
  ///
  /// The `eventFilter` function will overwrite the default behavior of
  ///  the [getEventsOnDay] function,
  /// which is used to display events on a given day in the [MonthView],
  ///  [DayView], and [WeekView].
  ///
  /// The `eventFilter` function takes a generic type parameter `T`, which
  ///  should match the type parameter used
  /// when creating the [EventController] instance. The function should
  ///  return a list of events of type `T`
  /// that occur on the specified date.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final eventController = EventController<Event>();
  ///
  /// // Define an event filter function that filters events by date
  /// eventController.eventFilter = (date) {
  ///   return events.where((event) => event.date == date).toList();
  /// };
  ///
  /// // Use the event controller in a calendar view
  /// final calendarView = MonthView<Event>(
  ///   eventController: eventController,
  /// );
  /// ```
  ///
  EventFilter<T>? get eventFilter => _eventFilter;

  //#endregion

  //#region Public Methods
  /// Add all the events in the list
  /// If there is an event with same date then
  void addAll(List<CalendarEventData<T>> events) {
    for (final event in events) {
      _addEvent(event);
    }

    notifyListeners();
  }

  /// Adds a new [event] to the calendar and notifies listeners.
  void add(CalendarEventData<T> event) {
    _addEvent(event);

    notifyListeners();
  }

  /// Removes [event] from this controller.
  void remove(CalendarEventData<T> event) {
    final date = event.date.withoutTime;

    // Removes the event from single event map.
    if (_calendarData.eventMap[date] != null) {
      if (_calendarData.eventMap[date]!.remove(event)) {
        _calendarData.events.remove(event);
        notifyListeners();
        return;
      }
    }

    // Removes the event from ranging or full day event.
    _calendarData.events.remove(event);
    _calendarData.eventRanges.remove(event);
    _calendarData.wholeDayEvents.remove(event);
    notifyListeners();
  }

  /// Removes all elements of the calendar data that satisfy the given
  ///  predicate.
  ///
  /// The `test` function should return `true` for elements to be removed.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = EventController();
  /// controller.removeWhere((event) => event.title == 'Meeting');
  /// ```
  void removeWhere(bool Function(CalendarEventData<T> value) element) {
    for (final e in _calendarData.eventMap.values) {
      e.removeWhere(element);
    }
    _calendarData.eventRanges.removeWhere(element);
    _calendarData.events.removeWhere(element);
    _calendarData.wholeDayEvents.removeWhere(element);
    notifyListeners();
  }

  /// Returns a list of [CalendarEventData] instances for the specified [date].
  ///
  /// If an [_eventFilter] has been set, it will be called with the specified
  ///  [date]
  /// and the current list of events, and its result will be returned instead
  ///  of the
  /// default behavior.
  ///
  /// Otherwise, this method will return a list of events that occur on the
  ///  specified
  /// [date], including events that span multiple days and full-day events.
  ///
  /// If there are no events on the specified [date], an empty list will be
  ///  returned.
  List<CalendarEventData<T>> getEventsOnDay(DateTime date) {
    if (_eventFilter != null) return _eventFilter!.call(date, this.events);

    final events = <CalendarEventData<T>>[];

    if (_calendarData.eventMap[date] != null) {
      events.addAll(_calendarData.eventMap[date]!);
    }

    /// Iterates through the list of ranging events and adds the events that
    ///  occur on the given date or have a date range that includes the given
    ///  date to the [events] list.
    ///
    /// - [_calendarData]: The calendar data containing the list of ranging
    ///  events.
    /// - [date]: The date to check for events.
    /// - [events]: The list to add the events to.
    ///
    /// Returns nothing.
    ///

    for (final rangingEvent in _calendarData.eventRanges) {
      if (date == rangingEvent.date ||
          date == rangingEvent.endDate ||
          (date.isBefore(rangingEvent.endDate) &&
              date.isAfter(rangingEvent.date))) {
        events.add(rangingEvent);
      }
    }

    events.addAll(getFullDayEvent(date));

    return events;
  }

  /// Returns full day events on given day.
  List<CalendarEventData<T>> getFullDayEvent(DateTime dateTime) {
    final events = <CalendarEventData<T>>[];
    for (final event in _calendarData.wholeDayEvents) {
      if (dateTime.difference(event.date).inDays >= 0 &&
          event.endDate.difference(dateTime).inDays > 0) {
        events.add(event);
      }
    }
    return events;
  }

  /// Updates the event filter with the provided [newFilter].
  /// If the new filter is different from the current filter, the current
  ///  filter is updated
  /// and all listeners are notified of the change.
  void updateFilter({required EventFilter<T> newFilter}) {
    if (newFilter != _eventFilter) {
      _eventFilter = newFilter;
      notifyListeners();
    }
  }

  //#endregion

  //#region Private Methods
  void _addEvent(CalendarEventData<T> event) {
    /// Asserts that the end date of the event is greater than or equal to the
    ///  start date.
    /// Throws an assertion error if the condition is not met.
    ///
    /// ```dart
    /// assert(
    ///   event.endDate.difference(event.date).inDays >= 0,
    ///   'The end date must be greater or equal to the start date',
    /// );
    /// ```
    ///
    /// The [event] parameter is an instance of the [Event] class.
    /// The [event.date] and [event.endDate] properties are of type [DateTime].
    ///
    /// This method is used in the [EventController] class to ensure that the
    ///  end date of an event is not before the start date.getFullDayEvent
    assert(
      event.endDate.difference(event.date).inDays >= 0,
      'The end date must be greater or equal to the start date',
    );
    if (_calendarData.events.contains(event)) return;
    if (event.endDate.difference(event.date).inDays > 0) {
      if (event.startTime!.isDayStart && event.endTime!.isDayStart) {
        _calendarData.wholeDayEvents.insertAscending(event);
      } else {
        _calendarData.eventRanges.insertAscending(event);
      }
    } else {
      final date = event.date.withoutTime;

      if (_calendarData.eventMap[date] == null) {
        _calendarData.eventMap.addAll({
          date: [event],
        });
      } else {
        _calendarData.eventMap[date]!.insertAscending(event);
      }
    }

    _calendarData.events.add(event);

    notifyListeners();
  }

//#endregion
}

/// A class that holds all the events for a calendar view.
class CalendarData<T> {
  /// Stores all the events in a list. All the items in the below 3 lists
  ///  will be
  /// available in this list as global itemList of all events.
  final events = <CalendarEventData<T>>[];

  /// Stores events that occur only once in a map. Here the key will be a day
  /// and along with the day as key, we will store all the events of that day as
  /// a list as value.
  final eventMap = <DateTime, List<CalendarEventData<T>>>{};

  /// A controller for managing events that occur over a range of dates.
  ///
  /// This controller only accepts events that have a date range, represented by
  /// a `CalendarEventData` object with a non-null `startDate` and `endDate`.
  /// Events that do not have a date range will not be added to the controller.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final controller = EventController<MyEventType>();
  ///
  /// // Add a new event to the controller
  /// // MyEventType` is a custom class that extends `Object`, for sample purposes.
  /// controller.addEvent(CalendarEventData<MyEventType>(
  ///   startDate: DateTime(2022, 1, 1),
  ///   endDate: DateTime(2022, 1, 3),
  ///   data: MyEventType('New Year\'s Day'),
  /// ));
  ///
  ///
  /// ```
  final eventRanges = <CalendarEventData<T>>[];

  /// Stores all full day events (24hr event).
  final wholeDayEvents = <CalendarEventData<T>>[];
}
