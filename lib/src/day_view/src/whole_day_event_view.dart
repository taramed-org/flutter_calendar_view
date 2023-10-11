import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template full_day_event_view}
/// This class is defined default view of whole day event
/// {@endtemplate}
class WholeDayEventView<T> extends StatelessWidget {
  /// This class is defined default view of full day event
  const WholeDayEventView({
    required this.events,
    required this.date,
    this.boxConstraints = const BoxConstraints(maxHeight: 100),
    this.padding,
    this.itemView,
    this.titleStyle,
    this.onEventTap,
    super.key,
  });

  /// Constraints for view
  final BoxConstraints boxConstraints;

  /// Define List of Event to display
  final List<CalendarEventData<T>> events;

  /// Define Padding of view
  final EdgeInsets? padding;

  /// Define custom Item view of Event.
  final Widget Function(CalendarEventData<T>? event)? itemView;

  /// Style for title
  final TextStyle? titleStyle;

  /// Called when user taps on event tile.
  final TileTapCallback<T>? onEventTap;

  /// Defines date for which events will be displayed.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: boxConstraints,
      child: ListView.builder(
        itemCount: events.length,
        padding: padding ?? EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onEventTap?.call(events[index], date),
          child: itemView?.call(events[index]) ??
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(1),
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: events[index].color,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  events[index].title,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        color: events[index].color.accent,
                      ),
                  maxLines: 1,
                ),
              ),
        ),
      ),
    );
  }
}
