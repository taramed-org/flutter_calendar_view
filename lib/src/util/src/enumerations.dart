// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// Note: Do not change sequence of this enumeration if not necessary
// this can change behaviour of month and week view.
/// Defines day of week
enum WeekDays {
  /// Monday: 0
  monday(code: 'monday', abbrevation: 'Monday'),

  /// Tuesday: 1
  tuesday(code: 'tuesday', abbrevation: 'T'),

  /// Wednesday: 2
  wednesday(code: 'wednesday', abbrevation: 'W'),

  /// Thursday: 3
  thursday(code: 'thursday', abbrevation: 'TH'),

  /// Friday: 4
  friday(code: 'friday', abbrevation: 'F'),

  /// Saturday: 5
  saturday(code: 'saturday', abbrevation: 'S'),

  /// Sunday: 6
  sunday(code: 'sunday', abbrevation: 'S');

  const WeekDays({
    required this.code,
    required this.abbrevation,
  });

  /// Code of day
  final String code;

  /// Abbrevation of day
  final String abbrevation;
}

/// Defines different minute slot sizes.
enum MinuteSlotSize {
  /// Slot size: 15 minutes
  minutes15(minutes: 15),

  /// Slot size: 30 minutes
  minutes30(minutes: 30),

  /// Slot size: 60 minutes
  minutes60(minutes: 60);

  const MinuteSlotSize({
    required this.minutes,
  });

  /// Minutes in slot
  final int minutes;
}

/// Defines different line styles
enum LineStyle {
  /// Solid line
  solid,

  /// Dashed line
  dashed,
}
