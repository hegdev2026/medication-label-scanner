part of 'ads_cubit.dart';

class AdsState extends Equatable {
  const AdsState({this.ready = false, this.privacyOptionsRequired = false});

  /// Consent is settled and the SDK is running.
  final bool ready;
  final bool privacyOptionsRequired;

  /// Ads appear only once the SDK is ready.
  bool get showAds => ready;

  @override
  List<Object?> get props => [ready, privacyOptionsRequired];
}
