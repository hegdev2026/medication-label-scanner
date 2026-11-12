import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medicine_lab_reader/core/database/app_database.dart';

/// Third-party objects that cannot be annotated directly.
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  Logger get logger => Logger(printer: PrettyPrinter(methodCount: 0));

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  Clock get clock => const Clock();

  @Named('isMobile')
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
}

/// Injectable clock so time-based logic is testable.
class Clock {
  const Clock();
  DateTime now() => DateTime.now();
}
