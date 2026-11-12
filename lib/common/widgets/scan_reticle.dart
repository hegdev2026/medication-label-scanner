import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';

/// Four rounded mint corner brackets that frame the OCR zone.
class ScanReticle extends StatelessWidget {
  const ScanReticle({
    super.key,
    this.armLength = 28,
    this.stroke = 3.5,
    this.inset = 8,
    this.radius = 10,
  });

  final double armLength;
  final double stroke;
  final double inset;
  final double radius;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      size: Size.infinite,
      painter: _ReticlePainter(
        color: AppColors.accent,
        armLength: armLength,
        stroke: stroke,
        inset: inset,
        radius: radius,
      ),
    ),
  );
}

class _ReticlePainter extends CustomPainter {
  const _ReticlePainter({
    required this.color,
    required this.armLength,
    required this.stroke,
    required this.inset,
    required this.radius,
  });

  final Color color;
  final double armLength, stroke, inset, radius;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final l = inset, t = inset, r = size.width - inset, b = size.height - inset;
    final a = armLength, rad = radius;
    final corners = <Path>[
      Path()
        ..moveTo(l, t + a)
        ..lineTo(l, t + rad)
        ..arcToPoint(Offset(l + rad, t), radius: Radius.circular(rad))
        ..lineTo(l + a, t),
      Path()
        ..moveTo(r - a, t)
        ..lineTo(r - rad, t)
        ..arcToPoint(Offset(r, t + rad), radius: Radius.circular(rad))
        ..lineTo(r, t + a),
      Path()
        ..moveTo(r, b - a)
        ..lineTo(r, b - rad)
        ..arcToPoint(Offset(r - rad, b), radius: Radius.circular(rad))
        ..lineTo(r - a, b),
      Path()
        ..moveTo(l + a, b)
        ..lineTo(l + rad, b)
        ..arcToPoint(Offset(l, b - rad), radius: Radius.circular(rad))
        ..lineTo(l, b - a),
    ];
    for (final p in corners) {
      canvas.drawPath(p, glow);
      canvas.drawPath(p, line);
    }
  }

  @override
  bool shouldRepaint(_ReticlePainter old) =>
      old.color != color ||
      old.armLength != armLength ||
      old.stroke != stroke ||
      old.inset != inset ||
      old.radius != radius;
}

/// A mint laser line sweeping up and down its parent. Animation only; it is
/// frozen when the platform asks for reduced motion.
class ScanLine extends StatefulWidget {
  const ScanLine({super.key});

  @override
  State<ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Align(
        alignment: Alignment(0, -0.88 + 1.76 * _controller.value),
        child: Container(
          width: double.infinity,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Solid across almost the whole width; only the very ends fade.
              colors: [
                AppColors.accent.withValues(alpha: 0),
                AppColors.accent,
                AppColors.accent,
                AppColors.accent.withValues(alpha: 0),
              ],
              stops: const [0, 0.06, 0.94, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.8),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
