import 'package:flutter/material.dart';

/// {@template safe_area_wrapper}
/// This widget is used to wrap calendar views to avoid system intrusions.
/// It extends [SafeArea] widget.
/// {@endtemplate}
class SafeAreaWrapper extends SafeArea {
  /// {@macro safe_area_wrapper}
  SafeAreaWrapper({
    required super.child,
    super.key,
    SafeAreaOption option = const SafeAreaOption(),
  }) : super(
          left: option.left,
          top: option.top,
          right: option.right,
          bottom: option.bottom,
          minimum: option.minimum,
          maintainBottomViewPadding: option.maintainBottomViewPadding,
        );
}

/// {@template safe_area_option}
/// This class is used to provide options to [SafeAreaWrapper].
///
/// [left], [top], [right], [bottom] are used to avoid system intrusions on
/// respective sides. By default all are true.
/// {@endtemplate}
class SafeAreaOption {
  /// {@macro safe_area_option}
  const SafeAreaOption({
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum insets and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeArea] should maintain the bottom
  /// [MediaQueryData.viewPadding] instead of the bottom
  /// [MediaQueryData.padding], defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewPadding;
}
