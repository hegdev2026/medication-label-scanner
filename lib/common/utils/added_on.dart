import 'package:easy_localization/easy_localization.dart';

/// "Today, 9:24 AM", "Yesterday, 4:10 PM" or "May 12, 2024". Pure given [now].
String formatAddedOn(DateTime date, DateTime now, String locale) {
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  final time = DateFormat.jm(locale).format(date);
  if (diff == 0) return 'common.todayAt'.tr(args: [time]);
  if (diff == 1) return 'common.yesterdayAt'.tr(args: [time]);
  return DateFormat.yMMMd(locale).format(date);
}
