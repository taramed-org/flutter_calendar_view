import 'package:calendar_view/src/booking_view/src/booking_helper.dart';
import 'package:flutter/material.dart';

/// {@template booking_slot}
/// A widget that represents a slot in the booking view.
/// {@endtemplate}
class BookingSlot extends StatelessWidget {
  /// {@macro booking_slot}
  const BookingSlot({
    required this.child,
    required this.isBooked,
    required this.onTap,
    required this.isSelected,
    required this.isPauseTime,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.pauseSlotColor,
    this.hideBreakSlot,
    super.key,
  });

  /// The child widget to display inside the slot.
  final Widget child;

  /// Whether the slot is already booked or not.
  final bool isBooked;

  /// Whether the slot represents a pause time or not.
  final bool isPauseTime;

  /// Whether the slot is currently selected or not.
  final bool isSelected;

  /// A callback function to be called when the slot is tapped.
  final VoidCallback onTap;

  /// The color to use for a booked slot.
  final Color? bookedSlotColor;

  /// The color to use for a selected slot.
  final Color? selectedSlotColor;

  /// The color to use for an available slot.
  final Color? availableSlotColor;

  /// The color to use for a pause slot.
  final Color? pauseSlotColor;

  /// Whether to hide the break slot or not.
  final bool? hideBreakSlot;

  /// Returns the color of the booking slot based on its availability and
  /// selection status.
  ///
  /// If the slot is a pause time, [pauseSlotColor] is returned. If the slot
  /// is already booked,
  /// [bookedSlotColor] is returned. If the slot is selected,
  /// [selectedSlotColor] is returned.
  /// Otherwise, [availableSlotColor] is returned.
  Color getSlotColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isPauseTime) {
      return pauseSlotColor ?? Theme.of(context).disabledColor;
    }

    if (isBooked) {
      return bookedSlotColor ?? getBookedColor(isDarkMode: isDarkMode);
    } else {
      return isSelected
          ? selectedSlotColor ?? Theme.of(context).primaryColor
          : availableSlotColor ?? getAvailableSlotColor(isDarkMode: isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (hideBreakSlot ?? true && isPauseTime)
        ? const SizedBox()
        : GestureDetector(
            onTap: (!isBooked && !isPauseTime) ? onTap : null,
            child: Card(
              // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: getSlotColor(context),
              child: child,
            ),
          );
  }
}
