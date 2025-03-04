// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template calendar_page_header}
/// A widget that displays the header of a calendar page.
///
/// The header displays the current date and provides buttons to navigate to
///  the previous and next days.
/// It also allows the user to define a range of dates by providing a secondary
///  date.
///
class CalendarPageHeader extends StatelessWidget {
  /// {@macro calendar_page_header}
  const CalendarPageHeader({
    required this.date,
    required this.dateStringBuilder,
    this.onNextDay,
    this.onTitleTapped,
    this.onPreviousDay,
    this.secondaryDate,
    this.headerStyle = const HeaderStyle(),
    super.key,
  });

  /// When user taps on right arrow.
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  final VoidCallback? onPreviousDay;

  /// When user taps on title.
  final AsyncCallback? onTitleTapped;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final StringProvider dateStringBuilder;

  /// Style for Calendar's header
  final HeaderStyle headerStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      decoration:
          // ignore_for_file: deprecated_member_use_from_same_package
          headerStyle.decoration ??
              BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (headerStyle.leftIconVisible)
            IconButton(
              onPressed: onPreviousDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.leftIconPadding,
              icon: headerStyle.leftIcon ??
                  Icon(
                    Icons.chevron_left,
                    size: 30,
                    // color: iconColor,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          Expanded(
            child: InkWell(
              onTap: onTitleTapped,
              child: Text(
                dateStringBuilder(date, secondaryDate: secondaryDate),
                textAlign: headerStyle.titleAlign,
                style: headerStyle.headerTextStyle,
              ),
            ),
          ),
          if (headerStyle.rightIconVisible)
            IconButton(
              onPressed: onNextDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.rightIconPadding,
              icon: headerStyle.rightIcon ??
                  Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
        ],
      ),
    );
  }
}
