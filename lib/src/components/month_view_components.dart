// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../extensions.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import 'common_components.dart';

class CircularCell extends StatelessWidget {
  /// Date of cell.
  final DateTime date;

  /// List of Events for current date.
  final List<CalendarEventData> events;

  /// Defines if [date] is [DateTime.now] or not.
  final bool shouldHighlight;

  /// Background color of circle around date title.
  final Color backgroundColor;

  /// Title color when title is highlighted.
  final Color highlightedTitleColor;

  /// Color of cell title.
  final Color titleColor;

  /// This class will defines how cell will be displayed.
  /// To get proper view user [CircularCell] with 1 [MonthView.cellAspectRatio].
  const CircularCell({
    Key? key,
    required this.date,
    this.events = const [],
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightedTitleColor = Constants.white,
    this.titleColor = Constants.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: shouldHighlight ? backgroundColor : Colors.transparent,
        child: Text(
          "${date.day}",
          style: TextStyle(
            fontSize: 20,
            color: shouldHighlight ? highlightedTitleColor : titleColor,
          ),
        ),
      ),
    );
  }
}

class FilledCell<T extends Object?> extends StatelessWidget {
  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    Key? key,
    required this.date,
    required this.events,
    required this.backgroundColor,
    required this.inMonthBackgroundColor,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.onTileTap,
    this.highlightRadius = 11,
    this.highlightColor,
    this.dateStringBuilder,
    this.titleStyle,
    this.highlightedTitleStyle,
  }) : super(key: key);

  /// Date of current cell.
  final DateTime date;

  /// Text style of title
  final TextStyle? titleStyle;

  /// Text style of highlighted title
  final TextStyle? highlightedTitleStyle;

  /// List of events on for current date.
  final List<CalendarEventData<T>> events;

  /// defines date string for current cell.
  final StringProvider? dateStringBuilder;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// In month background color of cell.
  final Color inMonthBackgroundColor;

  /// Defines highlight color.
  final Color? highlightColor;

  /// Called when user taps on any event tile.
  final TileTapCallback<T>? onTileTap;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  @override
  Widget build(BuildContext context) {
    final titleStyle = this.titleStyle ??
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            );

    final highlightedTitleStyle = this.highlightedTitleStyle ??
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            );

    return Container(
      color: isInMonth ? inMonthBackgroundColor : backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor: shouldHighlight
                ? isInMonth
                    ? highlightColor ?? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Colors.transparent,
            child: Text(
              dateStringBuilder?.call(date) ?? "${date.day}",
              style: shouldHighlight
                  ? highlightedTitleStyle
                  : isInMonth
                      ? titleStyle
                      : titleStyle.copyWith(
                          color: titleStyle.color!.withOpacity(0.2),
                        ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      events.length,
                      (index) => GestureDetector(
                        onTap: () =>
                            onTileTap?.call(events[index], events[index].date),
                        child: Container(
                          decoration: BoxDecoration(
                            color: events[index].color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 3.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  events[index].title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: events[0].titleStyle ??
                                      TextStyle(
                                        color: events[index].color.accent,
                                        fontSize: 12,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    Key? key,
    VoidCallback? onNextMonth,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousMonth,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextMonth,
          onPreviousDay: onPreviousMonth,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
          headerStyle: headerStyle,
        );
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month} - ${date.year}";
}

class WeekDayTile extends StatelessWidget {
  /// Title for week day in month view.
  const WeekDayTile({
    Key? key,
    required this.dayIndex,
    this.displayBorder = true,
    this.textStyle,
    this.backgroundColor,
    this.weekDayStringBuilder,
  }) : super(key: key);

  /// Index of week day.
  final int dayIndex;

  /// display week day
  final String Function(int)? weekDayStringBuilder;

  /// Background color of single week day tile.
  final Color? backgroundColor;

  /// Should display border or not.
  final bool displayBorder;

  /// Style for week day string.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: displayBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.5,
              )
            : null,
      ),
      child: Text(
        weekDayStringBuilder?.call(dayIndex) ?? Constants.weekTitles[dayIndex],
        style: textStyle ??
            Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
      ),
    );
  }
}
