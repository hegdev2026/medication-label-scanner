abstract final class AppRoutes {
  // Shell (tab) routes
  static const dashboard = '/';
  static const inventory = '/inventory';
  static const expiry = '/expiry';
  static const settings = '/settings';

  // Full-screen routes
  static const terms = '/settings/terms';
  static const privacy = '/settings/privacy';
  static const scan = '/scan';

  /// Opens the scanner and goes straight to the photo picker.
  static const scanGallery = '/scan?source=gallery';
  static const review = '/review';
  static const medicineNew = '/medicines/new';
  static const medicineDetails = '/medicines/:id';
  static const medicineEdit = '/medicines/:id/edit';

  static String details(int id) => '/medicines/$id';
  static String edit(int id) => '/medicines/$id/edit';
}
