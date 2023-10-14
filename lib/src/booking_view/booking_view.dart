import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/booking_view/src/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingView extends StatelessWidget {
  const BookingView(
      {Key? key,
      required this.controller,
      // required this.bookingService,
      required this.getBookingStream,
      required this.convertStreamResultToDateTimeRanges,
      this.onBookChange,
      this.bookingExplanation,
      this.bookingGridCrossAxisCount,
      this.bookingGridChildAspectRatio,
      this.formatDateTime,
      this.bookedSlotColor,
      this.selectedSlotColor,
      this.availableSlotColor,
      this.bookedSlotText,
      this.selectedSlotText,
      this.availableSlotText,
      this.availableSlotTextStyle,
      this.selectedSlotTextStyle,
      this.bookedSlotTextStyle,
      this.gridScrollPhysics,
      this.loadingWidget,
      this.errorWidget,
      // this.uploadingWidget,
      this.wholeDayIsBookedWidget,
      this.pauseSlotColor,
      this.pauseSlotText,
      // this.pauseSlots,
      this.hideBreakTime,
      this.locale,
      this.startingDayOfWeek = StartingDayOfWeek.monday,
      this.disabledDays,
      this.disabledDates,
      this.lastDay})
      : super(key: key);

  /// Controller for the booking calendar.
  final BookingController controller;

  // ///for the Calendar picker we use: [TableCalendar]
  // ///credit: https://pub.dev/packages/table_calendar

  // ///initial [ConsultationBooking] which contains the details of the service,
  // ///and this service will get additional two parameters:
  // ///the [ConsultationBooking.bookingStart] and [ConsultationBooking.bookingEnd] date of the booking
  // final ConsultationBooking bookingService;

  ///this function returns a [Stream] which will be passed to the [StreamBuilder],
  ///so we can track realtime changes in our Booking Calendar
  ///this is a callback function, and the calendar will call this function whenever the user changes the selected date
  ///and will pass the start and end parameters with the currently selected date (00:00 and 24:00)
  final Stream<dynamic>? Function(
      {required DateTime start, required DateTime end}) getBookingStream;

  ///The booking calendar accepts any type of [Stream]s, so using ducktyping, the stream generic type is [dynamic]
  ///This callback method will convert the stream result to [List<DateTimeRange>], because this package
  ///calculates the overlapping booking slots by this parameter
  ///This way you can have any other type used by your REST services, but this convert method
  ///will "serialize" it to a new type, because we only want to make calculation by the start and endDate
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

  /// `onBookSelected` is a callback function that's called when a booking slot
  /// is selected by the user.
  ///
  /// It's a `Future` function that takes a `ConsultationBooking` object as its argument.
  /// The `ConsultationBooking` object, `newBooking`, represents the booking slot
  /// that the user has selected.
  ///
  /// This function is meant to handle the action of booking a slot. Typically,
  /// this would involve sending the booking data to a server and waiting for
  /// a response to confirm the booking.
  ///
  /// This function should be provided by the parent widget or the application
  /// using the `BookingCalendar` widget.
  final Future<void> Function(ConsultationBooking newBooking)? onBookChange;

  ///this will be display above the Booking Slots, which can be used to give the user
  ///extra informations of the booking calendar (like Colors: default)
  final Widget? bookingExplanation;

  ///For the Booking Calendar Grid System, how many columns should be in the [GridView]
  final int? bookingGridCrossAxisCount;

  ///For the Booking Calendar Grid System, the aspect ratio of the elements in the [GridView]
  final double? bookingGridChildAspectRatio;

  ///The elements in the [GridView] will be [DateTime] texts
  ///and you can format with the help of this parameter
  final String Function(DateTime dt)? formatDateTime;

  ///The [Color] and the [Text] of the
  ///already booked, currently selected, yet available slot (or slot for the break time)
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;
  final TextStyle? bookedSlotTextStyle;
  final TextStyle? availableSlotTextStyle;
  final TextStyle? selectedSlotTextStyle;

  ///The [ScrollPhysics] of the [GridView] which shows the Booking Calendar
  final ScrollPhysics? gridScrollPhysics;

  ///Display your custom loading widget while fetching data from [Stream]
  final Widget? loadingWidget;

  ///Display your custom error widget if any error recurred while fetching data from [Stream]
  final Widget? errorWidget;

  // ///Display your custom  widget while uploading data to your database
  // final Widget? uploadingWidget;

  ///Display your custom  widget if every slot is booked and you want to show something special
  ///not only the red slots
  final Widget? wholeDayIsBookedWidget;

  // ///The pause time, where the slots won't be available
  // final List<DateTimeRange>? pauseSlots;

  ///True if you want to hide your break time from the calendar, and the explanation text as well
  final bool? hideBreakTime;

  ///for localizing the calendar, String code to locale property. (intl format) See: [https://pub.dev/packages/table_calendar#locale]
  final String? locale;

  ///What is the default starting day of the week in the tablecalendar. See [https://pub.dev/documentation/table_calendar/latest/table_calendar/StartingDayOfWeek.html]
  final StartingDayOfWeek? startingDayOfWeek;

  ///The days inside this list, won't be available in the calendar. Similarly to [DateTime.weekday] property, a week starts with Monday, which has the value 1. (Sunday=7)
  ///if you pass a number which includes "Today" as well, the first and focused day in the calendar will be the first available day after today
  final List<int>? disabledDays;

  ///The last date which can be picked in the calendar, everything after this will be disabled
  final DateTime? lastDay;

  ///Concrete List of dates when the day is unavailable, eg: holiday, everything is booked or you need to close or something.
  final List<DateTime>? disabledDates;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => controller,
      child: BookingCalendarMain(
        key: key,
        getBookingStream: getBookingStream,
        onBookChange: onBookChange,
        bookingStatusCaption: bookingExplanation,
        bookingGridChildAspectRatio: bookingGridChildAspectRatio,
        bookingGridCrossAxisCount: bookingGridCrossAxisCount,
        formatDateTime: formatDateTime,
        convertStreamResultToDateTimeRanges:
            convertStreamResultToDateTimeRanges,
        bookedSlotTextStyle: bookedSlotTextStyle,
        availableSlotTextStyle: availableSlotTextStyle,
        selectedSlotTextStyle: selectedSlotTextStyle,
        availableSlotColor: availableSlotColor,
        availableSlotText: availableSlotText,
        bookedSlotColor: bookedSlotColor,
        bookedSlotText: bookedSlotText,
        selectedSlotColor: selectedSlotColor,
        selectedSlotText: selectedSlotText,
        gridScrollPhysics: gridScrollPhysics,
        loadingWidget: loadingWidget,
        errorWidget: errorWidget,
        // uploadingWidget: uploadingWidget,
        wholeDayIsBookedWidget: wholeDayIsBookedWidget,
        pauseSlotColor: pauseSlotColor,
        pauseSlotText: pauseSlotText,
        hideBreakTime: hideBreakTime,
        locale: locale,
        startingDayOfWeek: startingDayOfWeek,
        disabledDays: disabledDays,
        lastDay: lastDay,
        disabledDates: disabledDates,
      ),
    );
  }
}
