enum ExpiryStatus {
  expired('expiry.expired'),
  within30('expiry.within30'),
  within60('expiry.within60'),
  within90('expiry.within90'),
  ok('expiry.ok'),
  none('expiry.none');

  const ExpiryStatus(this.labelKey);

  /// Translation key; show with `tr()`.
  final String labelKey;

  bool get isWarning =>
      this == expired ||
      this == within30 ||
      this == within60 ||
      this == within90;
}
