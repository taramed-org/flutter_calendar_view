// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/month_view/src/month_page_header.dart';
import 'package:calendar_view/src/month_view/src/month_view_components.dart';
import 'package:calendar_view/src/month_view/src/week_day_tile.dart';
import 'package:flutter/material.dart';

/// {@template month_view}
/// A widget that displays a month calendar.
/// {@endtemplate}
class MonthView<T extends Object?> extends StatefulWidget {
  /// {@macro month_view}
  const MonthView({
    super.key,
    this.controller,
    this.showBorder = true,
    this.borderColor,
    this.cellBuilder,
    this.minMonth,
    this.maxMonth,
    this.initialMonth,
    this.borderSize = 1,
    this.useAvailableVerticalSpace = false,
    this.cellAspectRatio = 0.55,
    this.headerBuilder,
    this.weekDayBuilder,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.width,
    this.onPageChange,
    this.onCellTap,
    this.onEventTap,
    this.onDateLongPress,
    this.startDay = WeekDays.monday,
    this.headerStringBuilder,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.headerStyle = const HeaderStyle(),
    this.safeAreaOption = const SafeAreaOption(),
    this.cellStyle,
  }) : assert(
          (cellBuilder != null && cellStyle == null) || (cellBuilder == null),
          'If cellBuilder is used, cellStyle must be null.',
        );

  /// A required parameters that controls events for month view.
  ///
  /// This will auto update month view when user adds events in controller.
  /// This controller will store all the events. And returns events
  /// for particular day.
  ///
  /// If [controller] is null it will take controller from
  /// [CalendarControllerProvider.controller].
  final EventController<T>? controller;

  /// A function that returns a [Widget] that determines appearance of
  /// each cell in month calendar.
  final CellBuilder<T>? cellBuilder;

  /// Builds month page title.
  ///
  /// Used default title builder if null.
  final DateWidgetBuilder? headerBuilder;

  /// This function will generate DateString in the calendar header.
  /// Useful for I18n
  final StringProvider? headerStringBuilder;

  /// This function will generate DayString in month view cell.
  /// Useful for I18n
  final StringProvider? dateStringBuilder;

  /// This function will generate WeeDayString in weekday view.
  /// Useful for I18n
  /// Ex : ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
  final String Function(int)? weekDayStringBuilder;

  /// Called when user changes month.
  final CalendarPageChangeCallBack? onPageChange;

  /// This function will be called when user taps on month view cell.
  final CellTapCallback<T>? onCellTap;

  /// This function will be called when user will tap on a single event
  /// tile inside a cell.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileTapCallback<T>? onEventTap;

  /// Builds the name of the weeks.
  ///
  /// Used default week builder if null.
  ///
  /// Here day will range from 0 to 6 starting from Monday to Sunday.
  final WeekDayBuilder? weekDayBuilder;

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.epochDate] is default.
  final DateTime? minMonth;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.maxDate] is default.
  final DateTime? maxMonth;

  /// Defines initial display month.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialMonth;

  /// Defines whether to show default borders or not.
  ///
  /// Default value is true
  ///
  /// Use [borderSize] to define width of the border and
  /// [borderColor] to define color of the border.
  final bool showBorder;

  /// Defines width of default border
  ///
  /// Default value is [Colors.blue]
  ///
  /// It will take affect only if [showBorder] is set.
  final Color? borderColor;

  /// Page transition duration used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Curve pageTransitionCurve;

  /// Defines width of default border
  ///
  /// Default value is 1
  ///
  /// It will take affect only if [showBorder] is set.
  final double borderSize;

  /// Automated Calculate cellAspectRatio using available vertical space.
  final bool useAvailableVerticalSpace;

  /// Defines aspect ratio of day cells in month calendar page.
  final double cellAspectRatio;

  /// Width of month view.
  ///
  /// If null is provided then It will take width of closest [MediaQuery].
  final double? width;

  /// This method will be called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  ///   /// Defines the day from which the week starts.
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Style for MontView header.
  final HeaderStyle headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Cell Style for MonthView.
  final MonthCellStyle? cellStyle;

  @override
  MonthViewState<T> createState() => MonthViewState<T>();
}

/// State of month view.
class MonthViewState<T extends Object?> extends State<MonthView<T>> {
  late DateTime _minDate;
  late DateTime _maxDate;

  late DateTime _currentDate;

  late int _currentIndex;

  int _totalMonths = 0;

  late PageController _pageController;

  late double _width;
  late double _height;

  late double _cellWidth;
  late double _cellHeight;

  late CellBuilder<T> _cellBuilder;

  late WeekDayBuilder _weekBuilder;

  late DateWidgetBuilder _headerBuilder;

  // EventController<T>? _controller;

  // late VoidCallback _reloadCallback;

  @override
  void initState() {
    super.initState();

    // _reloadCallback = _reload;

    _setDateRange();

    // Initialize current date.
    _currentDate = (widget.initialMonth ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();
    updateViewDimensions();
    // Initialize page controller to control page actions.
    _pageController = PageController(initialPage: _currentIndex);

    _assignBuilders();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final newController = widget.controller ??
  //       CalendarControllerProvider.of<T>(context).controller;

  //   if (newController != _controller) {
  //     _controller = newController;

  //     _controller!
  //       // Removes existing callback.
  //       ..removeListener(_reloadCallback)

  //       // Reloads the view if there is any change in controller or
  //       // user adds new events.
  //       ..addListener(_reloadCallback);
  //   }

  //   updateViewDimensions();
  // }

  // @override
  // void didUpdateWidget(MonthView<T> oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Update controller.
  //   final newController = widget.controller ??
  //       CalendarControllerProvider.of<T>(context).controller;

  //   if (newController != _controller) {
  //     _controller?.removeListener(_reloadCallback);
  //     _controller = newController;
  //     _controller?.addListener(_reloadCallback);
  //   }

  //   // Update date range.
  //   if (widget.minMonth != oldWidget.minMonth ||
  //       widget.maxMonth != oldWidget.maxMonth) {
  //     _setDateRange();
  //     _regulateCurrentDate();

  //     _pageController.jumpToPage(_currentIndex);
  //   }

  //   // Update builders and callbacks
  //   _assignBuilders();

  //   updateViewDimensions();
  // }

  @override
  void dispose() {
    // _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      option: widget.safeAreaOption,
      child: SizedBox(
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _width,
              child: _headerBuilder(_currentDate),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChange,
                itemBuilder: (_, index) {
                  final date = DateTime(_minDate.year, _minDate.month + index);
                  final weekDays = date.datesOfWeek(start: widget.startDay);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _width,
                        child: Row(
                          children: List.generate(
                            7,
                            (index) => Expanded(
                              child: SizedBox(
                                width: _cellWidth,
                                child:
                                    _weekBuilder(weekDays[index].weekday - 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cellAspectRatio =
                                widget.useAvailableVerticalSpace
                                    ? calculateCellAspectRatio(
                                        constraints.maxHeight,
                                      )
                                    : widget.cellAspectRatio;

                            return SizedBox(
                              height: _height,
                              width: _width,
                              child: _MonthPageBuilder<T>(
                                key: ValueKey(date.toIso8601String()),
                                onCellTap: widget.onCellTap,
                                onDateLongPress: widget.onDateLongPress,
                                width: _width,
                                height: _height,
                                controller:
                                    widget.controller ?? EventController<T>(),
                                borderColor: widget.borderColor ??
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                borderSize: widget.borderSize,
                                cellBuilder: _cellBuilder,
                                cellRatio: cellAspectRatio,
                                date: date,
                                showBorder: widget.showBorder,
                                startDay: widget.startDay,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                itemCount: _totalMonths,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // /// Returns [EventController] associated with this Widget.
  // ///
  // /// This will throw [AssertionError] if controller is called before its
  // /// initialization is complete.
  // EventController<T> get controller {
  //   if (_controller == null) {
  //     throw "EventController is not initialized yet.";
  //   }

  //   return _controller!;
  // }

  // void _reload() {
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  /// Updates the dimensions of the month view based on the provided `width`
  ///  or the width of the [MediaQuery] context.
  /// Calculates the width and height of each cell based on the aspect ratio
  /// provided by the `cellAspectRatio` property.
  void updateViewDimensions() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _cellWidth = _width / 7;
    _cellHeight = _cellWidth / widget.cellAspectRatio;
    _height = _cellHeight * 6;
  }

  /// Calculates the aspect ratio of a cell in the month view based on the
  /// given height.
  ///
  /// The aspect ratio is calculated by dividing the width of the cell by
  ///  the height of the cell.
  /// The height of the cell is calculated by dividing the given height by
  ///  6, since there are 6 rows in the month view.
  ///
  /// Returns the aspect ratio of the cell.
  double calculateCellAspectRatio(double height) {
    final cellHeight = height / 6;
    return _cellWidth / cellHeight;
  }

  void _assignBuilders() {
    // Initialize cell builder. Assign default if widget.cellBuilder is null.
    _cellBuilder = widget.cellBuilder ?? _defaultCellBuilder;

    // Initialize week builder. Assign default if widget.weekBuilder is null.
    // This widget will come under header this will display week days.
    _weekBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;

    // Initialize header builder. Assign default if widget.headerBuilder
    // is null.
    //
    // This widget will be displayed on top of the page.
    // from where user can see month and change month.
    _headerBuilder = widget.headerBuilder ?? _defaultHeaderBuilder;
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  ///
  void _regulateCurrentDate() {
    // make sure that _currentDate is between _minDate and _maxDate.
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    // Calculate the current index of page view.
    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    // Initialize minimum date.
    _minDate = (widget.minMonth ?? CalendarConstants.epochDate).withoutTime;

    // Initialize maximum date.
    _maxDate = (widget.maxMonth ?? CalendarConstants.maxDate).withoutTime;

    assert(
      _minDate.isBefore(_maxDate),
      'Minimum date should be less than maximum date.\n'
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    // Get number of months between _minDate and _maxDate.
    // This number will be number of page in page view.
    _totalMonths = _maxDate.getMonthDifference(_minDate);
  }

  /// Calls when user changes page using gesture or inbuilt methods.
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + (value - _currentIndex),
        );
        _currentIndex = value;
      });
    }
    widget.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Default month view header builder
  Widget _defaultHeaderBuilder(DateTime date) {
    return MonthPageHeader(
      onTitleTapped: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: _minDate,
          lastDate: _maxDate,
        );

        if (selectedDate == null) return;
        jumpToMonth(selectedDate);
      },
      onPreviousMonth: previousPage,
      date: date,
      dateStringBuilder: widget.headerStringBuilder,
      onNextMonth: nextPage,
      headerStyle: widget.headerStyle,
    );
  }

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(int index) {
    return WeekDayTile(
      dayIndex: index,
      weekDayStringBuilder: widget.weekDayStringBuilder,
    );
  }

  /// Default cell builder. This will be used if `widget.cellBuilder` is null.
  Widget _defaultCellBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
    bool isInMonth,
  ) {
    final backgroundColor = widget.cellStyle?.backgroundColor ??
        Theme.of(context).primaryColor.withOpacity(0.1);
    final inMonthBackgroundColor =
        widget.cellStyle?.inMonthBackgroundColor ?? Colors.transparent;
    return FilledCell<T>(
      date: date,
      shouldHighlight: isToday,
      backgroundColor: backgroundColor,
      inMonthBackgroundColor: inMonthBackgroundColor,
      // backgroundColor: isInMonth ? Constants.white : Constants.offWhite,
      events: events,
      isInMonth: isInMonth,
      onTileTap: widget.onEventTap,
      titleStyle: widget.cellStyle?.titleStyle,
      highlightedTitleStyle: widget.cellStyle?.highlightedTitleStyle,
      highlightColor: widget.cellStyle?.highlightColor,
      dateStringBuilder: widget.dateStringBuilder,
    );
  }

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToPage(
    int page, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _pageController.animateToPage(
      page,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives month calendar for [month]
  void jumpToMonth(DateTime month) {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw InvalidDateException(min: _minDate, max: _maxDate);
    }
    _pageController.jumpToPage(_minDate.getMonthDifference(month) - 1);
  }

  /// Animate to page which gives month calendar for [month].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToMonth(
    DateTime month, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw InvalidDateException(min: _minDate, max: _maxDate);
    }
    await _pageController.animateToPage(
      _minDate.getMonthDifference(month) - 1,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in month view.
  DateTime get currentDate => DateTime(_currentDate.year, _currentDate.month);
}

/// TODO: add a ink splash on tap and long press
/// {@template month_page_builder}
/// A builder that creates a page for a given month.
///
/// This builder is used by the [MonthView] to create pages for
/// each month
/// that is displayed in the calendar. It takes a [BuildContext] and a
///  [DateTime]
/// representing the month to build, and returns a [Widget] representing the
/// page.
/// {@endtemplate}
class _MonthPageBuilder<T> extends StatelessWidget {
  /// {@macro month_page_builder}
  const _MonthPageBuilder({
    required this.cellRatio,
    required this.showBorder,
    required this.borderSize,
    required this.borderColor,
    required this.cellBuilder,
    required this.date,
    required this.controller,
    required this.width,
    required this.height,
    required this.onCellTap,
    required this.onDateLongPress,
    required this.startDay,
    super.key,
  });
  final double cellRatio;
  final bool showBorder;
  final double borderSize;
  final Color borderColor;
  final CellBuilder<T> cellBuilder;
  final DateTime date;
  final EventController<T> controller;
  final double width;
  final double height;
  final CellTapCallback<T>? onCellTap;
  final DatePressCallback? onDateLongPress;
  final WeekDays startDay;

  @override
  Widget build(BuildContext context) {
    final monthDays = date.datesOfMonths(startDay: startDay);
    return SizedBox(
      width: width,
      height: height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: cellRatio,
        ),
        itemCount: 42,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final events = controller.getEventsOnDay(monthDays[index]);
          return GestureDetector(
            onTap: () => onCellTap?.call(events, monthDays[index]),
            onLongPress: () => onDateLongPress?.call(monthDays[index]),
            child: Container(
              decoration: BoxDecoration(
                border: showBorder
                    ? Border.all(
                        color: borderColor,
                        width: borderSize,
                      )
                    : null,
              ),
              child: cellBuilder(
                monthDays[index],
                events,
                monthDays[index].compareWithoutTime(DateTime.now()),
                monthDays[index].month == date.month,
              ),
            ),
          );
        },
      ),
    );
  }
}
