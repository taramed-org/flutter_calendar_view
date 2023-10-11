import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template event_scroll_configuration}
/// A configuration class that extends [ValueNotifier] to notify listeners when
///  an event is being scrolled.
///
/// The generic type `T` represents the type of the object associated with the
///  event.
///
/// The `value` property of this class represents whether an event is being
///  scrolled or not.
/// {@endtemplate}
class EventScrollConfiguration<T extends Object?> extends ValueNotifier<bool> {
  /// {@macro event_scroll_configuration}
  EventScrollConfiguration() : super(false);

  bool _shouldScroll = false;
  CalendarEventData<T>? _event;
  Duration? _duration;
  Curve? _curve;

  Completer<void>? _completer;

  /// Whether an event is being scrolled or not.
  bool get shouldScroll => _shouldScroll;

  /// The event that is being scrolled.
  CalendarEventData<T>? get event => _event;

  /// The duration of the scroll animation.
  Duration? get duration => _duration;

  /// The curve of the scroll animation.
  Curve? get curve => _curve;

  /// This function will be completed once [completeScroll] is called.
  Future<void> setScrollEvent({
    required CalendarEventData<T> event,
    required Duration? duration,
    required Curve? curve,
  }) {
    if (shouldScroll || _completer != null) return Future.value();

    _completer = Completer();

    _duration = duration;
    _curve = curve;
    _event = event;
    _shouldScroll = true;
    value = !value;

    return _completer!.future;
  }

  /// Resets the scroll event.
  void resetScrollEvent() {
    _event = null;
    _shouldScroll = false;
    _duration = null;
    _curve = null;
  }

  /// Completes the scroll event.
  void completeScroll() {
    _completer?.complete();
    _completer = null;
  }
}
