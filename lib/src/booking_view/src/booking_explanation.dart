import 'package:flutter/material.dart';

/// {@template booking_status_caption}
/// A widget that shows the booking status caption.
/// {@endtemplate}
class BookingStatusCaption extends StatelessWidget {
  /// {@macro booking_status_caption}
  const BookingStatusCaption({
    required this.color,
    required this.text,
    this.explanationIconSize,
    super.key,
  });

  /// The color of the explanation text.
  final Color color;

  /// The text to be displayed as the explanation.
  final String text;

  /// The size of the explanation icon, if any.
  final double? explanationIconSize;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: explanationIconSize ?? 16,
          width: explanationIconSize ?? 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text,
            style: themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
