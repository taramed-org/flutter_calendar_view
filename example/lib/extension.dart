import 'package:example/app_colors.dart';
import 'package:flutter/material.dart';

extension NavigationExtension on State {
  void pushRoute(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

extension NavigatorExtention on BuildContext {
  Future<T?> pushRoute<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (context) => page));

  void pop([dynamic value]) => Navigator.of(this).pop(value);

  void showSnackBarWithText(String text) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

extension ColorExtension on Color {
  Color get accentColor =>
      (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
          ? AppColors.black
          : AppColors.white;
}

// extension StringExt on String {
//   String get capitalized => toBeginningOfSentenceCase(this) ?? "";
// }

// extension ViewNameExt on CalendarView {
//   String get name => toString().split(".").last;
// }
