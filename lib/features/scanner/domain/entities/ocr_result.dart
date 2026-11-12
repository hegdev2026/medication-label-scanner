import 'package:equatable/equatable.dart';

class OcrBlock extends Equatable {
  const OcrBlock({
    required this.text,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });
  final String text;
  final double? left, top, right, bottom;
  @override
  List<Object?> get props => [text, left, top, right, bottom];
}

class OcrResult extends Equatable {
  const OcrResult({required this.text, this.blocks = const []});
  final String text;
  final List<OcrBlock> blocks;
  bool get isEmpty => text.trim().isEmpty;
  @override
  List<Object?> get props => [text, blocks];
}
