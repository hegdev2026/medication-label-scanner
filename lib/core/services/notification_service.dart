import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart';

/// Local expiry reminders (30 and 7 days before). Delivery time is chosen by
/// the OS and may be deferred; the app always shows expiry status in-app too.
@LazySingleton(as: ReminderScheduler)
class NotificationService implements ReminderScheduler {
  NotificationService(this._plugin, this._log);
  final FlutterLocalNotificationsPlugin _plugin;
  final Logger _log;

  static const _offsetsDays = [30, 7];
  bool _ready = false;

  // Windows has no support in the plugin for scheduled notifications.
  bool get _supported =>
      Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isLinux;

  Future<bool> _init() async {
    if (!_supported) return false;
    if (_ready) return true;
    try {
      tzdata.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
          macOS: DarwinInitializationSettings(),
          linux: LinuxInitializationSettings(defaultActionName: 'Open'),
        ),
      );
      if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
      _ready = true;
    } catch (e) {
      _log.w('Notifications unavailable: $e');
    }
    return _ready;
  }

  /// Stable ids: medicineId * 10 + offset index.
  int _id(int medicineId, int index) => medicineId * 10 + index;

  @override
  Future<void> schedule(Medicine medicine) async {
    final id = medicine.id;
    final expiry = medicine.expiryDate;
    if (id == null || expiry == null || !await _init()) return;

    for (var i = 0; i < _offsetsDays.length; i++) {
      final days = _offsetsDays[i];
      final when = DateTime(
        expiry.year,
        expiry.month,
        expiry.day,
        9,
      ).subtract(Duration(days: days));
      if (!when.isAfter(DateTime.now())) continue;
      try {
        await _plugin.zonedSchedule(
          id: _id(id, i),
          title: 'Medicine expiring soon',
          body:
              '${medicine.name} expires in about $days days. '
              'Check the printed label.',
          scheduledDate: tz.TZDateTime.from(when, tz.UTC),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'expiry',
              'Expiry reminders',
              channelDescription: 'Reminders before medicines expire',
            ),
            iOS: DarwinNotificationDetails(),
            macOS: DarwinNotificationDetails(),
            linux: LinuxNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        _log.w('Could not schedule reminder: $e');
      }
    }
  }

  @override
  Future<void> cancel(int medicineId) async {
    if (!await _init()) return;
    for (var i = 0; i < _offsetsDays.length; i++) {
      try {
        await _plugin.cancel(id: _id(medicineId, i));
      } catch (e) {
        _log.w('Could not cancel reminder: $e');
      }
    }
  }

  @override
  Future<void> rescheduleAll(List<Medicine> medicines) async {
    for (final m in medicines) {
      final id = m.id;
      if (id == null) continue;
      await cancel(id);
      await schedule(m);
    }
  }
}
