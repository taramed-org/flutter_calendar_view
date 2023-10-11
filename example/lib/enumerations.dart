enum CalendarView {
  month(name: 'Month'),
  day(name: 'Day'),
  week(name: 'Week');

  const CalendarView({required this.name});
  final String name;
}
