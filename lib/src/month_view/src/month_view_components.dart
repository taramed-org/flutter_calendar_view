// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template filled_cell}
/// A cell widget to display on month view.
/// {@endtemplate}
class FilledCell<T extends Object?> extends StatelessWidget {
  /// A cell widget to display on month view.
  const FilledCell({
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
    super.key,
  });

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

    return ColoredBox(
      color: isInMonth ? inMonthBackgroundColor : backgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor: shouldHighlight
                ? isInMonth
                    ? highlightColor ?? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Colors.transparent,
            child: Text(
              dateStringBuilder?.call(date) ?? '${date.day}',
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
                margin: const EdgeInsets.only(top: 5),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 3,
                          ),
                          padding: const EdgeInsets.all(2),
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

// class _CircularCell extends StatelessWidget {
//   /// This class will defines how cell will be displayed.
//   /// To get proper view user [_CircularCell] with 1 [MonthView.cellAspectRatio].
//   const _CircularCell({
//     Key? key,
//     required this.date,
//     this.events = const [],
//     this.shouldHighlight = false,
//     this.backgroundColor = Colors.blue,
//     this.highlightedTitleColor = Constants.white,
//     this.titleColor = Constants.black,
//   }) : super(key: key);

//   /// Date of cell.
//   final DateTime date;

//   /// List of Events for current date.
//   final List<CalendarEventData> events;

//   /// Defines if [date] is [DateTime.now] or not.
//   final bool shouldHighlight;

//   /// Background color of circle around date title.
//   final Color backgroundColor;

//   /// Title color when title is highlighted.
//   final Color highlightedTitleColor;

//   /// Color of cell title.
//   final Color titleColor;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CircleAvatar(
//         backgroundColor: shouldHighlight ? backgroundColor : Colors.transparent,
//         child: Text(
//           "${date.day}",
//           style: TextStyle(
//             fontSize: 20,
//             color: shouldHighlight ? highlightedTitleColor : titleColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
