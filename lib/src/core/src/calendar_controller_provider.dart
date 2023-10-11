import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/widgets.dart';

/// {@template calendar_controller_provider}
/// This will provide controller to its subtree.
/// If controller argument is not provided in calendar views then
/// controller from this class will be considered.
///
/// Use this widget to provide same controller object to all calendar
/// view widgets and synchronize events between them.
/// {@endtemplate}
class CalendarControllerProvider<T extends Object?> extends InheritedWidget {
  /// {@macro calendar_controller_provider}
  const CalendarControllerProvider({
    required this.controller,
    required super.child,
    super.key,
  });

  /// Event controller for Calendar views.
  final EventController<T> controller;

  /// Returns the nearest [CalendarControllerProvider] ancestor widget that
  ///  contains a `CalendarController` of type [T].
  ///
  /// Throws an [AssertionError] if a [CalendarControllerProvider] of type
  ///  [T] is not found in the widget tree.
  ///
  /// To solve this issue, either wrap the `MaterialApp` with a
  /// [CalendarControllerProvider] of type [T] or provide a
  /// `CalendarController` argument in the respective calendar view class.
  static CalendarControllerProvider<T> of<T extends Object?>(
    BuildContext context,
  ) {
    final result = context
        .dependOnInheritedWidgetOfExactType<CalendarControllerProvider<T>>();
    assert(
        result != null,
        'No CalendarControllerProvider<$T> found in context. '
        'To solve this issue either wrap material app with '
        "'CalendarControllerProvider<$T>' or provide controller argument in "
        'respected calendar view class.');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarControllerProvider oldWidget) =>
      oldWidget.controller != controller;
}
