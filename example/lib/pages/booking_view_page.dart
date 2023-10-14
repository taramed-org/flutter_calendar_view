import 'package:calendar_view/calendar_view.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingViewPage extends ConsumerStatefulWidget {
  const BookingViewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState extends ConsumerState<BookingViewPage> {
  final now = DateTime.now();
  late final ConsultationBooking mockConsultationService;
  late final BookingController mockBookingController;

  @override
  void initState() {
    super.initState();

    mockConsultationService = ConsultationBooking(
      doctorName: 'Mock Service',
      consultationDuration: 30,
      startTime: DateTime(2024, 8, 18, 10, 0), // 10:00 AM
      endTime: DateTime(2024, 8, 18, 11, 0), // 11:00 AM
    );

    mockBookingController = BookingController(
        serviceOpening: DateTime(2023, 8, 18, 8, 0), // 08:00 AM
        serviceClosing: DateTime(2023, 8, 18, 20, 0), // 05:00 PM

        consultationBooking: mockConsultationService,
        pauseSlots: generatePauseSlots());
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    // Mock data
    final bookings = [
      {
        'bookingStart': "2023-08-28T10:00:00.000+08:00",
        'bookingEnd':
            "2023-08-28T11:00:00.000+08:00", // Just an example for the end time
      },

      // ... add more mock bookings as needed
      {
        'bookingStart': "2023-08-28T12:00:00.000+00:00",
        'bookingEnd':
            "2023-08-28T13:00:00.000+00:00", // Just an example for the end time
      }
    ];

    return Stream.value(bookings);
  }

  Future<dynamic> onBookSelected(BuildContext context,
      {required ConsultationBooking newBooking}) async {
    // await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Created'),
          content: const Text('Your booking was successfully created.'),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    if (newBooking.startTime != null && newBooking.endTime != null) {
      converted.add(DateTimeRange(
          start: newBooking.startTime!, end: newBooking.endTime!));
      print('${newBooking.toJson()} has been uploaded');
      setState(() {});
    }
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    for (var booking in streamResult) {
      DateTime start = DateTime.parse(booking['bookingStart'] as String);
      DateTime end = DateTime.parse(booking['bookingEnd'] as String);
      converted.add(DateTimeRange(start: start, end: end));
    }

    return converted;

    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    // DateTime first = now;
    // DateTime tomorrow = now.add(Duration(days: 1));
    // DateTime second = now.add(const Duration(minutes: 55));
    // DateTime third = now.subtract(const Duration(minutes: 240));
    // DateTime fourth = now.subtract(const Duration(minutes: 500));
    // converted.add(
    //     DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    // converted.add(DateTimeRange(
    //     start: second, end: second.add(const Duration(minutes: 23))));
    // converted.add(DateTimeRange(
    //     start: third, end: third.add(const Duration(minutes: 15))));
    // converted.add(DateTimeRange(
    //     start: fourth, end: fourth.add(const Duration(minutes: 50))));

    // //book whole day example
    // converted.add(DateTimeRange(
    //     start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
    //     end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    // return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookingView(
        controller: mockBookingController,
        convertStreamResultToDateTimeRanges: convertStreamResultMock,
        getBookingStream: getBookingStreamMock,
        onBookChange: (ConsultationBooking newBooking) async {
          await onBookSelected(context, newBooking: newBooking);
        },
        // pauseSlots: ,
        pauseSlotText: 'LUNCH',
        hideBreakTime: false,
        loadingWidget: const Text('Fetching data...'),
        // uploadingWidget: const CircularProgressIndicator(),
        // locale: 'hu_HU',
        startingDayOfWeek: StartingDayOfWeek.tuesday,
        wholeDayIsBookedWidget:
            const Text('Sorry, for this day everything is booked'),
        //disabledDates: [DateTime(2023, 1, 20)],
        disabledDays: const [6, 7],
      ),
    );
  }
}
