import 'package:equatable/equatable.dart';

/// Failures carry a translation key in [message]; the UI shows `tr(message)`
/// (see `failure_text.dart`). [detail] is optional technical context.
abstract class Failure extends Equatable {
  const Failure(this.message, {this.detail});
  final String message;
  final String? detail;

  @override
  List<Object?> get props => [message, detail];
}

class StorageFailure extends Failure {
  const StorageFailure({super.detail}) : super('error.storage');
}

class OcrUnavailableFailure extends Failure {
  const OcrUnavailableFailure() : super('error.ocrUnavailable');
}

class OcrFailure extends Failure {
  const OcrFailure({super.detail}) : super('error.ocr');
}

class ImagePickFailure extends Failure {
  const ImagePickFailure({super.detail}) : super('error.imagePick');
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.detail}) : super('error.unknown');
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.detail}) : super('error.network');
}
