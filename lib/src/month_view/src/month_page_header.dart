import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template month_page_header}
/// Header for month view that extends [CalendarPageHeader].
/// {@endtemplate}
class MonthPageHeader extends CalendarPageHeader {
  /// {@macro month_page_header}
  const MonthPageHeader({
    required super.date,
    VoidCallback? onNextMonth,
    VoidCallback? onPreviousMonth,
    StringProvider? dateStringBuilder,
    super.onTitleTapped,
    super.key,
    super.headerStyle,
  }) : super(
          onNextDay: onNextMonth,
          onPreviousDay: onPreviousMonth,
          dateStringBuilder:
              dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
        );
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      '${date.month} - ${date.year}';
}
