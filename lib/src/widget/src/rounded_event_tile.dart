import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template rounded_event_tile}
///  A widget that displays an event in a rounded tile.
/// It used on `DayView` and `WeekView` to display events.
/// {@endtemplate}
class RoundedEventTile extends StatelessWidget {
  /// {@macro rounded_event_tile}
  const RoundedEventTile({
    required this.title,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.description = '',
    this.borderRadius = BorderRadius.zero,
    this.totalEvents = 1,
    this.backgroundColor = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
    super.key,
  });

  /// Title of the tile.
  final String title;

  /// Description of the tile.
  final String description;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int totalEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsets padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// Style for title
  final TextStyle? titleStyle;

  /// Style for description
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty)
            Expanded(
              child: Text(
                title,
                style: titleStyle ??
                    TextStyle(
                      fontSize: 20,
                      color: backgroundColor.accent,
                    ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          if (description.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  description,
                  style: descriptionStyle ??
                      TextStyle(
                        fontSize: 17,
                        color: backgroundColor.accent.withAlpha(200),
                      ),
                ),
              ),
            ),
          if (totalEvents > 1)
            Expanded(
              child: Text(
                '+${totalEvents - 1} more',
                style: (descriptionStyle ??
                        TextStyle(
                          color: backgroundColor.accent.withAlpha(200),
                        ))
                    .copyWith(fontSize: 17),
              ),
            ),
        ],
      ),
    );
  }
}
