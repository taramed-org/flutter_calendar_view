import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/booking_view/src/booking_explanation.dart';
import 'package:calendar_view/src/booking_view/src/booking_helper.dart';
import 'package:calendar_view/src/booking_view/src/booking_slot.dart';
import 'package:calendar_view/src/model/src/starting_day_of_week.dart' as bc;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

/// {@template booking_calendar_main}
/// The sub-widget of `Booking which contains the [TableCalendar]
///  and the [GridView] of the booking slots.
/// {@endtemplate}
class BookingCalendarMain extends StatefulWidget {
  /// {@macro booking_calendar_main}
  const BookingCalendarMain({
    required this.getBookingStream,
    required this.convertStreamResultToDateTimeRanges,
    this.onBookChange,
    this.bookingStatusCaption,
    this.bookingGridCrossAxisCount,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.calendarBackgroundColor,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.bookedSlotTextStyle,
    this.selectedSlotText,
    this.selectedSlotTextStyle,
    this.availableSlotText,
    this.availableSlotTextStyle,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
    this.wholeDayIsBookedWidget,
    this.pauseSlotColor,
    this.pauseSlotText,
    this.hideBreakTime = false,
    this.locale,
    this.startingDayOfWeek,
    this.disabledDays,
    this.disabledDates,
    this.lastDay,
    this.calendarStyle,
    super.key,
  });

  /// A function that returns a stream of dynamic data for a given time range.
  ///
  /// The function takes two required parameters: `start` and `end`, both of
  /// type `DateTime`.
  /// It returns a stream of dynamic data that represents the bookings
  /// for the given time range.
  final Stream<dynamic>? Function({
    required DateTime start,
    required DateTime end,
  }) getBookingStream;

  /// A callback function that is called when a new booking is made.
  /// The `newBooking` parameter represents the newly created booking.
  /// If `newBooking` is null, it means that the booking was cancelled.
  final Future<void> Function(ConsultationBooking newBooking)? onBookChange;

  /// A function that takes a stream result and returns a list of
  /// [DateTimeRange] objects.
  /// The `streamResult` parameter is required and should not be null.
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

  /// Enables you to customize the booking status caption. It contains to
  /// explain the meaning of the colors used in the booking slots.
  final Widget? bookingStatusCaption;

  /// The number of columns in the booking grid.
  final int? bookingGridCrossAxisCount;

  /// The aspect ratio of the booking grid.
  final double? bookingGridChildAspectRatio;

  /// A function that takes a [DateTime] and returns a [String]
  /// representing the formatted date and time.
  final String Function(DateTime dt)? formatDateTime;

  /// The color used to indicate a booked slot.
  final Color? bookedSlotColor;

  /// The color used to indicate a selected slot.
  final Color? selectedSlotColor;

  /// The color used to indicate an available slot.
  final Color? availableSlotColor;

  /// The color used to indicate a paused slot.
  final Color? pauseSlotColor;

  /// The background color of the calendar.
  final Color? calendarBackgroundColor;

  /// The text to display for a booked slot.
  final String? bookedSlotText;

  /// The text to display for a selected slot.
  final String? selectedSlotText;

  /// The text to display for an available slot.
  final String? availableSlotText;

  /// The text to display for a paused slot.
  final String? pauseSlotText;

  /// The text style to use for a booked slot.
  final TextStyle? bookedSlotTextStyle;

  /// The text style to use for an available slot.
  final TextStyle? availableSlotTextStyle;

  /// The text style to use for a selected slot.
  final TextStyle? selectedSlotTextStyle;

  /// The scroll physics to use for the grid.
  final ScrollPhysics? gridScrollPhysics;

  /// The widget to display while loading.
  final Widget? loadingWidget;

  /// The widget to display when an error occurs.
  final Widget? errorWidget;

  /// Whether to hide break time slots.
  final bool? hideBreakTime;

  /// The last day to display on the calendar.
  final DateTime? lastDay;

  /// The locale to use for the calendar.
  final String? locale;

  /// The starting day of the week for the calendar.
  final bc.StartingDayOfWeek? startingDayOfWeek;

  /// The days of the week to disable.
  final List<int>? disabledDays;

  /// The dates to disable.
  final List<DateTime>? disabledDates;

  /// The widget to display when the whole day is booked.
  final Widget? wholeDayIsBookedWidget;

  /// The style to use for the calendar.
  final CalendarStyle? calendarStyle;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<BookingController>();
    final firstDay = calculateFirstDay();

    startOfDay = firstDay.startOfDayService(controller.serviceOpening);
    endOfDay = firstDay.endOfDayService(controller.serviceClosing);
    _focusedDay = firstDay;
    _selectedDay = firstDay;
    controller.selectFirstDayByHoliday(startOfDay, endOfDay);
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime startOfDay;
  late DateTime endOfDay;

  /// Calculates the start and end of the selected day based on the service
  /// opening and closing times.
  /// Sets the [startOfDay] and [endOfDay] variables accordingly.
  /// Resets the selected slot in the [controller].
  void selectNewDateRange() {
    startOfDay = _selectedDay.startOfDayService(controller.serviceOpening);
    endOfDay = _selectedDay
        .add(const Duration(days: 1))
        .endOfDayService(controller.serviceClosing);

    controller
      ..base = startOfDay
      ..resetSelectedSlot();
  }

  /// Calculates the first day to display on the calendar.
  /// If `widget.disabledDays` is not null, it checks if the current day
  /// is disabled.
  /// If the current day is disabled, it returns the first available day
  /// after the current day.
  /// If the current day is not disabled, it returns the current day.
  /// If `widget.disabledDays` is null, it returns the current day.
  ///
  /// For example scenario:
  ///
  /// ``` dart
  /// final disabledDays = [2, 4, 6]; // Wednesday, Friday, Sunday are disabled
  /// final bookingCalendar = BookingCalendar(disabledDays: disabledDays);

  /// final now = DateTime(2022, 11, 1); // Assume today is Tuesday, Nov 1, 2022
  /// final firstDay = bookingCalendar.calculateFirstDay();

  /// print(firstDay); // Output: 2022-11-01 (Tuesday is not disabled)
  /// ```
  DateTime calculateFirstDay() {
    final now = DateTime.now();
    if (widget.disabledDays != null) {
      return widget.disabledDays!.contains(now.weekday)
          ? now.add(Duration(days: getFirstMissingDay(now.weekday)))
          : now;
    } else {
      return DateTime.now();
    }
  }

  /// Returns the number of days to add to the current day to get the first
  /// available day.
  ///
  /// For example scenario:
  ///
  /// ``` dart
  /// final disabledDays = [2, 4, 6]; // Wednesday, Friday, Sunday are disabled
  /// final bookingCalendar = BookingCalendar(disabledDays: disabledDays);

  /// final now = 3; // Assume today is Tuesday (day 3)
  /// final firstMissingDay = bookingCalendar.getFirstMissingDay(now);

  /// print(firstMissingDay); // Output: 1 (Thursday is the first non-disabled day)
  /// ```
  int getFirstMissingDay(int now) {
    for (var i = 1; i <= 7; i++) {
      if (!widget.disabledDays!.contains(now + i)) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    controller = context.watch<BookingController>();

    return Consumer<BookingController>(
      builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Card(
                child: TableCalendar<ConsultationBooking>(
                  startingDayOfWeek: widget.startingDayOfWeek?.toTC() ??
                      tc.StartingDayOfWeek.monday,
                  holidayPredicate: (day) {
                    if (widget.disabledDates == null) return false;

                    var isHoliday = false;
                    for (final holiday in widget.disabledDates!) {
                      if (isSameDay(day, holiday)) {
                        isHoliday = true;
                      }
                    }
                    return isHoliday;
                  },
                  enabledDayPredicate: (day) {
                    if (widget.disabledDays == null &&
                        widget.disabledDates == null) return true;

                    var isEnabled = true;
                    if (widget.disabledDates != null) {
                      for (final holiday in widget.disabledDates!) {
                        if (isSameDay(day, holiday)) {
                          isEnabled = false;
                        }
                      }
                      if (!isEnabled) return false;
                    }
                    if (widget.disabledDays != null) {
                      isEnabled = !widget.disabledDays!.contains(day.weekday);
                    }

                    return isEnabled;
                  },
                  locale: widget.locale,
                  firstDay: calculateFirstDay(),
                  lastDay: widget.lastDay ??
                      DateTime.now().add(const Duration(days: 1000)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  calendarStyle: widget.calendarStyle ??
                      CalendarStyle(
                        disabledTextStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                                ),
                        defaultTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: isDarkMode ? FontWeight.w500 : null,
                            ),
                        selectedTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      selectNewDateRange();
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: widget.bookingStatusCaption ??
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          BookingStatusCaption(
                            color: widget.availableSlotColor ??
                                getAvailableSlotColor(isDarkMode: isDarkMode),
                            text: widget.availableSlotText ?? 'Available',
                          ),
                          BookingStatusCaption(
                            color: widget.selectedSlotColor ??
                                Theme.of(context).primaryColor,
                            text: widget.selectedSlotText ?? 'Selected',
                          ),
                          BookingStatusCaption(
                            color: widget.bookedSlotColor ??
                                getBookedColor(isDarkMode: isDarkMode),
                            text: widget.bookedSlotText ?? 'Booked',
                          ),
                          if (widget.hideBreakTime != null &&
                              widget.hideBreakTime == false)
                            BookingStatusCaption(
                              color: widget.pauseSlotColor ?? Colors.grey,
                              text: widget.pauseSlotText ?? 'Break',
                            ),
                        ],
                      ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverFillRemaining(
              child: StreamBuilder<dynamic>(
                stream:
                    widget.getBookingStream(start: startOfDay, end: endOfDay),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return widget.errorWidget ??
                        Center(
                          child: Text(snapshot.error.toString()),
                        );
                  }

                  if (!snapshot.hasData) {
                    return widget.loadingWidget ??
                        const Center(child: CircularProgressIndicator());
                  }

                  ///this snapshot should be converted to List<DateTimeRange>
                  final data = snapshot.requireData;
                  controller.generateBookedSlots(
                    widget.convertStreamResultToDateTimeRanges(
                      streamResult: data,
                    ),
                  );
                  // return Container();

                  return (widget.wholeDayIsBookedWidget != null &&
                          controller.isWholeDayBooked())
                      ? widget.wholeDayIsBookedWidget!
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.allBookingSlots.length,
                          itemBuilder: (context, index) {
                            TextStyle? getTextStyle() {
                              if (controller.isSlotBooked(index)) {
                                return widget.bookedSlotTextStyle;
                              } else if (index == controller.selectedSlot) {
                                return widget.selectedSlotTextStyle;
                              } else {
                                return widget.availableSlotTextStyle;
                              }
                            }

                            final slot =
                                controller.allBookingSlots.elementAt(index);
                            return BookingSlot(
                              hideBreakSlot: widget.hideBreakTime,
                              pauseSlotColor: widget.pauseSlotColor,
                              availableSlotColor: widget.availableSlotColor,
                              bookedSlotColor: widget.bookedSlotColor,
                              selectedSlotColor: widget.selectedSlotColor,
                              isPauseTime: controller.isSlotInPauseTime(slot),
                              isBooked: controller.isSlotBooked(index),
                              isSelected: index == controller.selectedSlot,
                              onTap: () {
                                if (controller.isSlotBooked(index)) {
                                  return;
                                }
                                controller.select(index);
                                widget.onBookChange?.call(controller.value);
                              },
                              child: Center(
                                child: Text(
                                  widget.formatDateTime?.call(slot) ??
                                      BookingUtil.formatDateTime(slot),
                                  style: getTextStyle() ??
                                      Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                widget.bookingGridCrossAxisCount ?? 3,
                            childAspectRatio:
                                widget.bookingGridChildAspectRatio ?? 1.5,
                          ),
                        );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
