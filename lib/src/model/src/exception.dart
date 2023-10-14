/// {@template calendar_view_exception}
/// Base class for all exceptions thrown by calendar views.
/// {@endtemplate}
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

/// {@template booking_view_exception}
/// Base class for all exceptions thrown by booking views.
/// {@endtemplate}
class BookingViewException implements Exception {
  /// {@macro booking_view_exception}
  BookingViewException(this.message, [this.stackTrace]);

  /// The message associated with this exception.
  final String message;

  /// The stack trace associated with this exception.
  final StackTrace? stackTrace;
  @override
  String toString() => message;
}

/// {@template booking_slot_exception}
/// Exception thrown when a booking slot is invalid. For example, if a slot is
/// before the minimum slot or after the maximum slot.
/// {@endtemplate}
class BookingSlotException extends BookingViewException {
  /// {@macro booking_slot_exception}
  BookingSlotException({
    String message = 'Booking Consultation closing must be after opening',
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}
