import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template week_day_tile}
/// Single tile for week day.
/// {@endtemplate}
class WeekDayTile extends StatelessWidget {
  /// {@macro week_day_tile}
  const WeekDayTile({
    required this.dayIndex,
    this.displayBorder = true,
    this.textStyle,
    this.backgroundColor,
    this.weekDayStringBuilder,
    super.key,
  });

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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
