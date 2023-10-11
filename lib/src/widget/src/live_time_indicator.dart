// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

/// {@template live_time_indicator}
/// A widget that displays a live time indicator, which updates in real-time to
///  show the current time.
///
/// This widget is typically used in conjunction with a calendar view
/// (specifically `DayView` and `WeekView`) to show
///  the current time as a vertical line
/// that moves along with the current time. The live time indicator can be
///  customized with various properties,
/// such as the color and thickness of the line, and the size and shape of the
///  indicator dot.
///

/// {@endtemplate}
class LiveTimeIndicator extends StatefulWidget {
  /// {@macro live_time_indicator}
  const LiveTimeIndicator({
    required this.width,
    required this.height,
    required this.timeLineWidth,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    super.key,
  });

  /// Width of indicator
  final double width;

  /// Height of total display area indicator will be displayed
  /// within this height.
  final double height;

  /// Width of time line use to calculate offset of indicator.
  final double timeLineWidth;

  /// settings for time line. Defines color, extra offset,
  /// and height of indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  /// Defines height occupied by one minute.
  final double heightPerMinute;

  @override
  _LiveTimeIndicatorState createState() => _LiveTimeIndicatorState();
}

class _LiveTimeIndicatorState extends State<LiveTimeIndicator> {
  late Timer _timer;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();

    _currentDate = DateTime.now();
    _timer = Timer(const Duration(seconds: 1), setTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Creates an recursive call that runs every 1 seconds.
  /// This will rebuild TimeLineIndicator every second. This will allow us
  /// to indicate live time in Week and Day view.
  void setTimer() {
    if (mounted) {
      setState(() {
        _currentDate = DateTime.now();
        _timer = Timer(const Duration(seconds: 1), setTimer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: CurrentTimeLinePainter(
        color: widget.liveTimeIndicatorSettings.color,
        height: widget.liveTimeIndicatorSettings.height,
        offset: Offset(
          widget.timeLineWidth + widget.liveTimeIndicatorSettings.offset,
          _currentDate.getTotalMinutes * widget.heightPerMinute,
        ),
      ),
    );
  }
}
