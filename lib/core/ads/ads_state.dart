part of 'ads_cubit.dart';

class AdsState extends Equatable {
  const AdsState({
    this.ready = false,
    this.adFreeUntil,
    this.privacyOptionsRequired = false,
  });

  /// Consent is settled and the SDK is running.
  final bool ready;
  final DateTime? adFreeUntil;
  final bool privacyOptionsRequired;

  bool isAdFree(DateTime now) {
    final until = adFreeUntil;
    return until != null && now.isBefore(until);
  }

  /// Ads appear only once the SDK is ready and no ad-free time is running.
  bool showAds(DateTime now) => ready && !isAdFree(now);

  AdsState copyWith({DateTime? adFreeUntil}) => AdsState(
    ready: ready,
    adFreeUntil: adFreeUntil ?? this.adFreeUntil,
    privacyOptionsRequired: privacyOptionsRequired,
  );

  @override
  List<Object?> get props => [ready, adFreeUntil, privacyOptionsRequired];
}
