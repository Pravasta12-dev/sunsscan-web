import 'package:intl/intl.dart';

class CustomDateFormat {
  DateTime localDateTime({required DateTime date}) {
    return date.toLocal();
  }

  String timeZoneName({required DateTime date}) {
    var dateLocal = localDateTime(date: date);
    return dateLocal.timeZoneName;
  }

  String formatDate({
    required DateTime date,
    String formatDate = 'dd MMMM yyyy',
    String locale = "id_ID",
  }) {
    var dateLocal = localDateTime(date: date);
    return DateFormat(formatDate, locale).format(dateLocal);
  }

  // 08:00
  String getFormattedTime({required DateTime date}) {
    return formatDate(date: date, formatDate: 'HH:mm');
  }

  String getFormattedFullDate({required DateTime date}) {
    return formatDate(date: date, formatDate: 'dd MMMM yyyy');
  }

  // Jan 10, 2025, 08:00 - Jan 12, 2025, 17:00
  String getFormattedEventDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    String formattedStartDate = formatDate(
      date: startDate,
      formatDate: 'MMM dd, yyyy, HH:mm',
    );
    String formattedEndDate = formatDate(
      date: endDate,
      formatDate: 'MMM dd, yyyy, HH:mm',
    );
    return '$formattedStartDate - $formattedEndDate';
  }

  // Jan 2, 2025, 08:00
  String getFormattedEventDate({required DateTime date}) {
    return formatDate(date: date, formatDate: 'MMM d, yyyy, HH:mm');
  }

  String getFormattedToday({
    required DateTime date,
    String format = 'yyyy-MM-dd',
  }) {
    return formatDate(date: date, formatDate: format);
  }

  String getFormattedNextday({
    required DateTime date,
    String format = 'yyyy-MM-dd',
  }) {
    var newDate = date.add(Duration(days: 1));
    return formatDate(date: newDate, formatDate: format);
  }

  String getFirstDayMonth({required DateTime date}) {
    var newDate = DateTime(date.year, date.month, 1);
    return formatDate(date: newDate, formatDate: 'yyyy-MM-dd');
  }

  String getLastDayMonth({required DateTime date}) {
    var newDate = DateTime(date.year, date.month + 1, 0);
    return formatDate(date: newDate, formatDate: 'yyyy-MM-dd');
  }

  String toIso8601WithOffset(DateTime dateTime) {
    final offset = dateTime.timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';

    final formattedOffset = '$sign$hours:$minutes';

    return dateTime.toIso8601String() + formattedOffset;
  }
}
