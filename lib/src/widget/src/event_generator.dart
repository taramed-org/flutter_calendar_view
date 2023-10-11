import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template event_generator}
/// A widget that display event tiles in day/week view.
/// {@endtemplate}
class EventGenerator<T extends Object?> extends StatelessWidget {
  /// {@macro event_generator}
  const EventGenerator({
    required this.height,
    required this.width,
    required this.events,
    required this.heightPerMinute,
    required this.eventArranger,
    required this.eventTileBuilder,
    required this.date,
    required this.onTileTap,
    required this.scrollNotifier,
    super.key,
  });

  /// Height of display area
  final double height;

  /// width of display area
  final double width;

  /// List of events to display.
  final List<CalendarEventData<T>> events;

  /// Defines height of single minute in day/week view page.
  final double heightPerMinute;

  /// Defines how to arrange events.
  final EventArranger<T> eventArranger;

  /// Defines how event tile will be displayed.
  final EventTileBuilder<T> eventTileBuilder;

  /// Defines date for which events will be displayed in given display area.
  final DateTime date;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// A notifier that notifies when user scrolls to event.
  final EventScrollConfiguration scrollNotifier;

  /// Arrange events and returns list of [Widget] that displays event
  /// tile on display area. This method uses [eventArranger] to get position
  /// of events and [eventTileBuilder] to display events.
  List<Widget> _generateEvents(BuildContext context) {
    final events = eventArranger.arrange(
      events: this.events,
      height: height,
      width: width,
      heightPerMinute: heightPerMinute,
    );

    return List.generate(events.length, (index) {
      return Positioned(
        top: events[index].top,
        bottom: events[index].bottom,
        left: events[index].left,
        right: events[index].right,
        child: GestureDetector(
          onTap: () => onTileTap?.call(events[index].events, date),
          child: Builder(
            builder: (context) {
              if (scrollNotifier.shouldScroll &&
                  events[index]
                      .events
                      .any((element) => element == scrollNotifier.event)) {
                _scrollToEvent(context);
              }
              return eventTileBuilder(
                date,
                events[index].events,
                Rect.fromLTWH(
                  events[index].left,
                  events[index].top,
                  width - events[index].right - events[index].left,
                  height - events[index].bottom - events[index].top,
                ),
                events[index].startDuration,
                events[index].endDuration,
              );
            },
          ),
        ),
      );
    });
  }

  void _scrollToEvent(BuildContext context) {
    final duration = scrollNotifier.duration ?? Duration.zero;
    final curve = scrollNotifier.curve ?? Curves.ease;

    scrollNotifier.resetScrollEvent();

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) async {
      try {
        await Scrollable.ensureVisible(
          context,
          duration: duration,
          curve: curve,
          alignment: 0.5,
        );
      } finally {
        scrollNotifier.completeScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: _generateEvents(context),
      ),
    );
  }
}
