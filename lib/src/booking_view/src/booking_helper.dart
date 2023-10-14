import 'package:flutter/material.dart';

/// The color used to represent available slots in light mode.
const availalbeSlotColor = Colors.green;

/// The color used to represent available slots in dark mode.
const availableSlotDarkColor = Color(0xFF00E676);

/// The color used to represent booked slots in light mode.
const bookedSlotColor = Colors.red;

/// The color used to represent booked slots in dark mode.
const bookedSlotDarkColor = Color(0xFFE53935);

/// Returns the color used to represent available slots based on the
/// current mode.
///
/// If [isDarkMode] is true, returns [availableSlotDarkColor], otherwise
/// returns [availalbeSlotColor].
Color getAvailableSlotColor({required bool isDarkMode}) {
  if (isDarkMode) {
    return availableSlotDarkColor;
  }
  return availalbeSlotColor;
}

/// Returns the color used to represent booked slots based on the current mode.
///
/// If [isDarkMode] is true, returns [bookedSlotDarkColor], otherwise returns
/// [bookedSlotColor].
Color getBookedColor({required bool isDarkMode}) {
  if (isDarkMode) {
    return bookedSlotDarkColor;
  }
  return bookedSlotColor; // Darker shade of red
}
