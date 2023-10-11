// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template default_timeline_mark}
/// This class is defined default view of timeline mark
/// {@endtemplate}
class DefaultTimelineMark extends StatelessWidget {
  /// Time marker for timeline used in week and day view.
  const DefaultTimelineMark({
    required this.date,
    this.markingStyle,
    this.timeStringBuilder,
    super.key,
  });

  /// Defines date for which time marker will be displayed.
  final DateTime date;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Text style for time string.
  final TextStyle? markingStyle;

  @override
  Widget build(BuildContext context) {
    final hour = ((date.hour - 1) % 12) + 1;
    final timeString = (timeStringBuilder != null)
        ? timeStringBuilder!(date)
        : date.minute != 0
            ? '$hour:${date.minute}'
            : "$hour ${date.hour ~/ 12 == 0 ? "am" : "pm"}";
    return Transform.translate(
      offset: const Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: Text(
          timeString,
          textAlign: TextAlign.right,
          style: markingStyle ??
              const TextStyle(
                fontSize: 15,
              ),
        ),
      ),
    );
  }
}
