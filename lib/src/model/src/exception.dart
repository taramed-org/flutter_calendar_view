/// {@template calendar_view_exception}
class CalendarViewException implements Exception {
  /// {@macro calendar_view_exception}
  CalendarViewException(this.message, [this.stackTrace]);

  /// The message associated with this exception.
  final String message;

  /// The stack trace associated with this exception.
  final StackTrace? stackTrace;
  @override
  String toString() => message;
}

/// {@template invalid_date_exception}
/// Exception thrown when a date is invalid. For example, if a date is before
/// the minimum date or after the maximum date.
/// {@endtemplate}
class InvalidDateException extends CalendarViewException {
  /// {@macro invalid_date_exception}
  InvalidDateException({
    required DateTime min,
    required DateTime max,
    StackTrace? stackTrace,
  }) : super('Invalid date. Date must be between $min and $max', stackTrace);
}
