import 'package:calendar_view/calendar_view.dart';

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    required super.date,
    super.key,
    super.onNextDay,
    super.onTitleTapped,
    super.onPreviousDay,
    StringProvider? dateStringBuilder,
    super.headerStyle,
  }) : super(
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
        );

  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      '${date.day} - ${date.month} - ${date.year}';
}
