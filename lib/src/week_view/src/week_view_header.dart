// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';

/// {@template week_page_header}
/// A header widget to display on week view.
/// {@endtemplate}
class WeekPageHeader extends CalendarPageHeader {
  /// A header widget to display on week view.
  const WeekPageHeader({
    required DateTime startDate,
    required DateTime endDate,
    super.key,
    super.onNextDay,
    super.onTitleTapped,
    super.onPreviousDay,
    StringProvider? headerStringBuilder,
    super.headerStyle,
  }) : super(
          date: startDate,
          secondaryDate: endDate,
          dateStringBuilder:
              headerStringBuilder ?? WeekPageHeader._weekStringBuilder,
        );
  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      '${date.day} / ${date.month} / ${date.year} to '
      "${secondaryDate != null ? "${secondaryDate.day} / "
          "${secondaryDate.month} / ${secondaryDate.year}" : ""}";
}
