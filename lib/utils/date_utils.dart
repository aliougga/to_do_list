import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateTime(DateTime dateTime) {
    final day = DateFormat('E').format(dateTime); // Mer
    final dayNumber = DateFormat('d').format(dateTime); // 11
    final month = DateFormat('LLL').format(dateTime); // avril
    final year = DateFormat('y').format(dateTime); // 2023
    final hour = DateFormat.Hm().format(dateTime); // 11:20

    return '$day, $dayNumber $month $year $hour';
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  // Convertir une date en chaîne au format 'yyyy-MM-dd HH:mm:ss'
  static String dateToString(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

// Convertir une chaîne en date en utilisant le format 'yyyy-MM-dd HH:mm:ss'
  static DateTime stringToDate(String dateString) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.parse(dateString);
  }
}
