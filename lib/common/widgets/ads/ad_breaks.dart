import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/ads/break_policy.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';

/// Runs whatever the ad rules allow right after a medicine was added: nothing,
/// or a full-screen ad at this natural break.
Future<void> runAdBreakAfterAdd() async {
  final ads = sl<AdsCubit>();
  if (ads.nextBreak() == AdBreak.interstitial) await ads.showInterstitial();
}
