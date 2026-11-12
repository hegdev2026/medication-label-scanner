import 'package:easy_localization/easy_localization.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';

String failureText(Failure failure) {
  final base = failure.message.tr();
  final detail = failure.detail;
  return detail == null ? base : '$base ($detail)';
}
