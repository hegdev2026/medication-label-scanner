/// Everything the app needs from the ad SDK that is not a widget: consent,
/// start-up and full-screen ads. Kept behind an interface so the rules around
/// it (frequency, ad-free time) can be tested without the SDK.
abstract class AdService {
  /// Asks for consent where the law requires it (EEA/UK/other regions), then
  /// starts the SDK. True when ads may be requested; never throws.
  Future<bool> start();

  /// Whether the user must be offered a way to change their ad choices.
  Future<bool> get privacyOptionsRequired;
  Future<void> showPrivacyOptions();

  /// Shows a loaded interstitial. False when none was ready or it failed.
  Future<bool> showInterstitial();

  /// Plays a rewarded video. True only when the user earned the reward.
  Future<bool> showRewarded();
}
