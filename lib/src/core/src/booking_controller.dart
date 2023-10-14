import 'dart:collection';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template booking_controller}
/// This class is used to manage the booking process.
/// {@endtemplate}
class BookingController extends ChangeNotifier {
  /// {@macro booking_controller}
  BookingController({
    required this.serviceOpening,
    required this.serviceClosing,
    required ConsultationBooking consultationBooking,
    List<DateTimeRange>? pauseSlots,
  }) : _consultationBooking = consultationBooking {
    // serviceOpening = consultationBooking.startTime;
    // serviceClosing = consultationBooking.endTime;
    _pauseSlots = pauseSlots ?? [];
    if (serviceOpening.isAfter(serviceClosing)) {
      throw BookingSlotException();
    }
    base = serviceOpening;
    _generateBookingSlots();
    _initializeSelectedSlot();
  }

  ///for the Calendar picker we use: `table_calendar` package
  ///credit: https://pub.dev/packages/table_calendar

  ///initial [ConsultationBooking] which contains the details of the service,
  ///and this service will get additional two parameters:
  ///the [ConsultationBooking] `startTime` and [ConsultationBooking] `endTime`
  /// date of the booking
  ConsultationBooking _consultationBooking;

  /// The base time of the service.
  late DateTime base;

  /// The opening time of the service, it indicates the available time for the
  /// booking, specified by the doctor.
  DateTime serviceOpening;

  /// The closing time of the service, it indicates the available time for the
  /// booking, specified by the doctor.
  DateTime serviceClosing;

  /// It indicates the list of all booking slots.
  /// The slots are generated based on the service duration and the service
  /// opening and closing time.
  ///
  /// For example, if the service duration is 30 minutes and the service opening
  /// time is 08:00 and the service closing time is 16:00, then the list of all
  /// booking slots will be:
  ///
  /// [08:00, 08:30, 09:00, 09:30, 10:00, 10:30, ..., 15:30, 16:00]
  ///
  /// Some of this slot might be booked, and some of them might be available or
  /// not available because of the pause time.
  // ! Cannot be a final list because it will be updated when the service
  // ! opening and closing time are changed.
  List<DateTime> _allBookingSlots = [];

  /// The list of all booked slots.
  final List<DateTimeRange> _bookedSlots = [];

  ///The pause time, where the slots won't be available
  // ! Cannot be a final list because it will be updated in constructor
  // ! when the pause time is provided.
  late List<DateTimeRange> _pauseSlots;

  // List<DateTime> get allBookingSlots => _allBookingSlots;

  /// Unmodifiable getter for the list of all booked slots.
  UnmodifiableListView<DateTime> get allBookingSlots =>
      UnmodifiableListView(_allBookingSlots);

  /// Unmodifiable getter for the list of all booked slots.
  UnmodifiableListView<DateTimeRange> get bookedSlots =>
      UnmodifiableListView(_bookedSlots);

  /// Unmodifiable getter for the list of all paused slots.
  UnmodifiableListView<DateTimeRange>? get pauseSlots =>
      UnmodifiableListView(_pauseSlots);

  // bool get isUploading => _isUploading;

  /// Getters for the [ConsultationBooking] instance.
  ConsultationBooking get value => _consultationBooking;

  /// The selected slot index.
  ///
  /// As default it is set to -1, which means no slot is selected.
  int _selectedSlot = -1;
  // bool _isUploading = false;

  /// The selected slot index.
  int get selectedSlot => _selectedSlot;

  /// Initializes the selected slot based on the consultation booking's start
  /// and end time.
  /// Extracts the time only (ignoring year, month, and day) from both DateTime
  /// objects.
  /// Calculates the difference between the start time and the service opening
  /// time.
  /// Determines the slot based on the service duration.
  ///
  /// For example, if the service duration is 30 minutes and the service opening
  /// time is 08:00 and the service closing time is 16:00, then the list of all
  /// booking slots will be:
  ///
  /// [08:00, 08:30, 09:00, 09:30, 10:00, 10:30, ..., 15:30, 16:00]
  ///
  /// If the start time is 09:00 and the end time is 10:00, then the selected
  /// slot will be 2, which is the third slot in the list.
  /// So the selected slot will be 09:30, when the controller is initialized.
  void _initializeSelectedSlot() {
    if (_consultationBooking.startTime != null &&
        _consultationBooking.endTime != null) {
      // Extract time only (ignoring year, month, and day) from both DateTime
      // objects
      final startTime = DateTime(0, 0, 0).copyWith(
        hour: _consultationBooking.startTime!.hour,
        minute: _consultationBooking.startTime!.minute,
      );
      final serviceOpeningTime = DateTime(0, 0, 0).copyWith(
        hour: serviceOpening.hour,
        minute: serviceOpening.minute,
      );

      // Calculate the difference between the startTime and the serviceOpening
      final difference = startTime.difference(serviceOpeningTime);

      // Determine the slot based on the service duration
      _selectedSlot =
          (difference.inMinutes / _consultationBooking.consultationDuration)
              .floor();
    }
  }

  /// Sets the service opening and closing times to the given [first] and
  /// [firstEnd] dates,
  /// respectively, and generates the booking slots based on the new settings.
  ///
  /// For example, if the service duration is 30 minutes and the service opening
  /// time is 08:00 and the service closing time is 16:00, then the list of all
  /// booking slots will be:
  ///
  /// [08:00, 08:30, 09:00, 09:30, 10:00, 10:30, ..., 15:30, 16:00]
  ///
  /// If the service opening time is changed to 09:00 and the service closing
  /// time is changed to 17:00, then the list of all booking slots will be:
  ///
  /// [09:00, 09:30, 10:00, 10:30, 11:00, 11:30, ..., 16:30, 17:00]
  ///
  /// This function triggered when there is a change in the service opening or
  /// closing time. It trigger this function because might the current day is
  /// disabled, and the system will try to find the next available day. And
  /// when it finds the next available day, it will set the service opening and
  /// closing times to the new day's opening and closing times. Then it will
  /// generate the booking slots based on the new settings.
  ///
  /// For example, if the set disabled day are[JUN 1, JUN 2, JUN 3, JUN 4]
  /// and the service opening time is 08:00 and the service closing time is
  /// 16:00, then the list of all booking slots will be:
  ///
  /// [JUN 5 08:00, JUN 5 08:30, JUN 5 09:00,..., JUN 5 15:30, JUN 5 16:00]
  void selectFirstDayByHoliday(DateTime first, DateTime firstEnd) {
    serviceOpening = first;
    serviceClosing = firstEnd;
    base = first;
    _generateBookingSlots();
  }

  /// This code generates a list of all possible booking slots based on the
  /// service duration, service opening time, and service closing time.
  /// It uses the _maxServiceFitInADay() function to calculate the maximum
  ///  number of services that can fit in a day based on the service
  /// duration and the service opening and closing times.

  /// Then, it uses the List.generate() method to generate a list of
  /// booking slots. The List.generate() method takes two arguments:
  /// the length of the list and a function that generates each element
  /// of the list. In this case, the length of the list is
  /// _maxServiceFitInADay(), and the function generates each element of
  ///  the list by adding the service duration to the base time
  /// (which is the service opening time) multiplied by the index of the
  /// element.

  /// The result is a list of all possible booking slots for the given
  ///  service duration, service opening time, and service closing time.
  void _generateBookingSlots() {
    _allBookingSlots.clear();

    /// copying the base time to avoid changing the original value
    final baseCopy = base.copyWith();

    _allBookingSlots = List.generate(
      _maxServiceFitInADay(),
      (index) => baseCopy.add(
        Duration(
              minutes: _consultationBooking.consultationDuration,
            ) *
            index,
      ),
    );

    final dateTime = DateTime.now();

    // Filter out slots that are before the current time
    _allBookingSlots.removeWhere((slot) => slot.isBefore(dateTime));

    // // Add booked slots even if they are before the current time
    // _allBookingSlots.addAll(_bookedSlots);
  }

  /// This function checks if the whole day is booked or not.
  /// It iterates over all booking slots and checks if each slot is booked or
  /// not. If any slot is not booked, it returns false. Otherwise, it returns
  /// true.
  bool isWholeDayBooked() {
    var isBooked = true;
    for (var i = 0; i < allBookingSlots.length; i++) {
      if (!isSlotBooked(i)) {
        isBooked = false;
        break;
      }
    }
    return isBooked;
  }

  /// Calculates the maximum number of services that can fit in a day based on
  ///  the provided service opening and closing times.
  /// If no service opening and closing times are provided, the calculation is
  ///  based on a 24-hour period.
  /// The calculation rounds down if the whole service cannot fit in the last
  ///  hours.
  /// Returns an integer representing the maximum number of services that can
  ///  fit in a day.
  /// For example, if the service duration is 30 minutes and the service opening
  /// time is 08:00 and the service closing time is 16:00, then the maximum
  /// number of services that can fit in a day is 16. Because there are 8 hours
  /// between 08:00 and 16:00, and each service takes 30 minutes, so 16 services
  /// can accommodate in 8 hours.
  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate
    /// with 00:00-24:00
    var openingHours = 24;

    openingHours = DateTimeRange(start: serviceOpening, end: serviceClosing)
        .duration
        .inHours;

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / _consultationBooking.consultationDuration)
        .floor();
  }

  /// The function checks if a given slot is already booked by comparing
  /// it with the existing booked slots.
  ///
  /// Args:
  ///   index (int): The index parameter represents the index of the slot
  ///   in the allBookingSlots list that you want to check if it is booked
  ///   or not.
  ///
  /// Returns:
  ///   a boolean value.
  bool isSlotBooked(int index) {
    // Get the slot date by using the index parameter to get the slot date
    final slotSelected = allBookingSlots.elementAt(index);
    var result = false;
    for (final slot in bookedSlots) {
      if (BookingUtil.isOverLapping(
        firstStart: slot.start,
        firstEnd: slot.end,
        secondStart: slotSelected,
        secondEnd: slotSelected.add(
          Duration(
            minutes: _consultationBooking.consultationDuration,
          ),
        ),
      )) {
        result = true;
        break;
      }
    }
    return result;
  }

  /// Resets the selected slot to -1, which means no slot is selected.
  void resetSelectedSlot() {
    _selectedSlot = -1;
    notifyListeners();
  }

  /// Generates the booking slots based on the new settings.
  Future<void> generateBookedSlots(List<DateTimeRange> data) async {
    _bookedSlots.clear();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      _bookedSlots.add(item);
    }
    _generateBookingSlots();
  }

  /// Selects a booking slot at the given index and updates the consultation
  ///  booking accordingly.
  ///
  /// The selected slot is stored in [_selectedSlot]. The start and end times
  ///  of the [_consultationBooking]
  /// are updated based on the selected slot and the consultation duration.
  ///  Finally, the listeners are notified
  /// of the changes.
  void select(int index) {
    _selectedSlot = index;
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    _consultationBooking
      ..startTime = bookingDate
      ..endTime = (bookingDate
          .add(Duration(minutes: _consultationBooking.consultationDuration)));
    _consultationBooking = _consultationBooking;
    notifyListeners();
  }

  /// Checks if the given [slot] overlaps with any of the pause slots.
  /// Returns true if the slot is in a pause time, false otherwise.
  bool isSlotInPauseTime(DateTime slot) {
    var result = false;
    if (_pauseSlots.isEmpty) {
      return result;
    }
    for (final pauseSlot in _pauseSlots) {
      if (BookingUtil.isOverLapping(
        firstStart: pauseSlot.start,
        firstEnd: pauseSlot.end,
        secondStart: slot,
        secondEnd: slot.add(
          Duration(
            minutes: _consultationBooking.consultationDuration,
          ),
        ),
      )) {
        result = true;
        break;
      }
    }
    return result;
  }
}
