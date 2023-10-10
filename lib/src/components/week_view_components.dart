// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import 'common_components.dart';

class WeekPageHeader extends CalendarPageHeader {
  /// A header widget to display on week view.
  const WeekPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    required DateTime startDate,
    required DateTime endDate,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? headerStringBuilder,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: startDate,
          secondaryDate: endDate,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              headerStringBuilder ?? WeekPageHeader._weekStringBuilder,
          headerStyle: headerStyle,
        );
  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} / ${date.month} / ${date.year} to "
      "${secondaryDate != null ? "${secondaryDate.day} / "
          "${secondaryDate.month} / ${secondaryDate.year}" : ""}";
}
