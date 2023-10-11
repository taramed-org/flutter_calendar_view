import 'package:flutter/widgets.dart';

/// {@template cell_style}
/// Style for calendar's cell.
/// {@endtemplate}
class MonthCellStyle {
  /// {@macro cell_style}
  const MonthCellStyle({
    this.titleStyle,
    this.highlightedTitleStyle,
    this.backgroundColor,
    this.inMonthBackgroundColor,
    this.highlightColor,
  });

  ///  Text style for cell.
  final TextStyle? titleStyle;

  /// Text style for highlighted cell.
  final TextStyle? highlightedTitleStyle;

  /// Background color of cell.
  final Color? backgroundColor;

  /// In month background color of cell.
  final Color? inMonthBackgroundColor;

  /// Highlight color of cell.
  final Color? highlightColor;
}
