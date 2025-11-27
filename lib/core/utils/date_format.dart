import 'package:clock/clock.dart';
import 'package:intl/intl.dart';

String formatEventDateRange(DateTime start, DateTime end) {
  final dfDayFull = DateFormat.yMEd();
  final dfDayNoYear = DateFormat.MEd();
  final dfTime = DateFormat('H:mm');

  final sDay = DateTime(start.year, start.month, start.day);
  final eDay = DateTime(end.year, end.month, end.day);

  if (sDay == eDay) {
    return '${dfDayFull.format(start)} '
        '${dfTime.format(start)}～${dfTime.format(end)}';
  } else if (start.year == end.year) {
    return '${dfDayFull.format(start)} ${dfTime.format(start)}～'
        '${dfDayNoYear.format(end)} ${dfTime.format(end)}';
  } else {
    return '${dfDayFull.format(start)} ${dfTime.format(start)}～'
        '${dfDayFull.format(end)} ${dfTime.format(end)}';
  }
}

extension DateTimeExt on DateTime {
  String formatRelativeTime() {
    final now = clock.now();
    final difference = now.difference(this);

    if (difference.inDays > 6) {
      // 1週間以上前の場合は年月日を返す
      return '1週間以上前';
    } else if (difference.inDays > 0) {
      // 1週間以内の場合は「x週間前」を返す
      return '${difference.inDays}週間前';
    } else if (difference.inHours > 0) {
      // 1日以内の場合は「x時間前」を返す
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      // 1時間以内の場合は「x分前」を返す
      return '${difference.inMinutes}分前';
    } else {
      // 1分以内の場合は「今日」を返す
      return '1分前';
    }
  }
}
