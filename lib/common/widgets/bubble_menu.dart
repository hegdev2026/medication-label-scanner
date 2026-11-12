import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/utils/platform_style.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// One row of a [showBubbleMenu].
class BubbleMenuItem<T> {
  const BubbleMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.subtitle,
    this.enabled = true,
    this.danger = false,
  });

  final T value;
  final String label;
  final IconData? icon;

  /// The icon's own colour; the accent when null.
  final Color? iconColor;

  /// A second, smaller line under the label.
  final String? subtitle;

  /// Off, the row is dimmed and cannot be picked.
  final bool enabled;

  /// The label is written in the danger colour (Delete, Cancel).
  final bool danger;
}

enum _Side { below, left, above }

/// An action menu with a pointer to the tapped button ([anchor]). It opens
/// below the button; with no room there it opens to the left, then above; with
/// no room anywhere it first scrolls the list the button is in so the menu
/// fits. Resolves to the chosen item's value, or null when dismissed.
///
/// [ios] picks the look: the iPhone bubble (rounded-square icon badges,
/// chevrons, hairlines, no dimming) or the Material bubble (round icon badges,
/// rounded rows, dimmed scrim behind). Defaults to the platform's own.
Future<T?> showBubbleMenu<T>(
  BuildContext anchor, {
  required List<BubbleMenuItem<T>> items,
  bool? ios,
}) async {
  final isIos = ios ?? isIosStyle(anchor);
  final metrics = _Metrics(
    ios: isIos,
    count: items.length,
    subtitles: items.any((i) => i.subtitle != null),
  );
  var rect = _rectOf(anchor);
  if (rect == null) return null;
  final screen = MediaQuery.sizeOf(anchor);
  final insets = MediaQuery.paddingOf(anchor);
  var side = metrics.sideFor(rect, screen, insets);
  if (side == null) {
    await Scrollable.ensureVisible(
      anchor,
      alignment: 0.35,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
    if (!anchor.mounted) return null;
    rect = _rectOf(anchor) ?? rect;
    side = metrics.sideFor(rect, screen, insets) ?? _Side.below;
  }
  if (!anchor.mounted) return null;
  final placed = side;
  final target = rect;
  return showDialog<T>(
    context: anchor,
    // Material dims what is behind the menu; iOS does not.
    barrierColor: AppColors.textPrimary.withValues(alpha: isIos ? 0 : 0.32),
    // The menu is placed in screen coordinates, so no safe-area shift.
    useSafeArea: false,
    builder: (dialogContext) => _Layer<T>(
      anchor: target,
      side: placed,
      metrics: metrics,
      items: items,
      onPick: (value) => dialogContext.pop(value),
    ),
  );
}

Rect? _rectOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) return null;
  final overlay = Navigator.of(
    context,
    rootNavigator: true,
  ).context.findRenderObject();
  final origin = overlay is RenderBox
      ? box.localToGlobal(Offset.zero, ancestor: overlay)
      : box.localToGlobal(Offset.zero);
  return origin & box.size;
}

Color get _tint => AppColors.isDark
    ? Color.alphaBlend(AppColors.accent.withValues(alpha: 0.12), AppColors.card)
    : AppColors.inset;

/// The menu's size, worked out from its rows so a side can be chosen before it
/// is built.
class _Metrics {
  const _Metrics({
    required this.ios,
    required this.count,
    this.subtitles = false,
  });
  final bool ios;
  final int count;
  final bool subtitles;

  static const double width = 232;
  static const double gap = 10;
  static const double arrow = 11;
  static const double androidPad = AppSpace.xs + 2;

  double get rowHeight => (ios ? 48 : 50) + (subtitles ? 10 : 0);
  double get height =>
      count * rowHeight +
      (ios ? (count - 1) + 2 * AppSpace.xs : 2 * androidPad);

  _Side? sideFor(Rect anchor, Size screen, EdgeInsets insets) {
    final top = insets.top + AppSpace.sm;
    final bottom = screen.height - insets.bottom - AppSpace.sm;
    final needed = height + gap + arrow;
    if (anchor.bottom + needed <= bottom) return _Side.below;
    final leftRoom = anchor.left - gap - arrow >= width + AppSpace.sm;
    if (leftRoom && height <= bottom - top) return _Side.left;
    if (anchor.top - needed >= top) return _Side.above;
    return null;
  }
}

class _Layer<T> extends StatelessWidget {
  const _Layer({
    required this.anchor,
    required this.side,
    required this.metrics,
    required this.items,
    required this.onPick,
  });

  final Rect anchor;
  final _Side side;
  final _Metrics metrics;
  final List<BubbleMenuItem<T>> items;
  final ValueChanged<T> onPick;

  /// How far the menu extends past the button's centre along the edge, so the
  /// pointer clears the rounded corner.
  static const double _reach = 38;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final insets = MediaQuery.paddingOf(context);
    const margin = AppSpace.sm;
    final width = _Metrics.width.clamp(0.0, screen.width - margin * 2);
    final height = metrics.height;

    final double left;
    final double? top;
    final double? bottom;
    final Alignment origin;
    final Alignment pointerAt;
    final double pointerOffset;

    switch (side) {
      case _Side.below || _Side.above:
        left = (anchor.center.dx + _reach - width).clamp(
          margin,
          screen.width - width - margin,
        );
        pointerOffset = (anchor.center.dx - left - _Pointer.span / 2).clamp(
          AppSpace.sm,
          width - AppSpace.sm - _Pointer.span,
        );
        final x = ((anchor.center.dx - left) / width * 2 - 1).clamp(-1.0, 1.0);
        if (side == _Side.below) {
          top = anchor.bottom + _Metrics.gap;
          bottom = null;
          pointerAt = Alignment.topLeft;
          origin = Alignment(x, -1);
        } else {
          top = null;
          bottom = screen.height - anchor.top + _Metrics.gap;
          pointerAt = Alignment.bottomLeft;
          origin = Alignment(x, 1);
        }
      case _Side.left:
        left = anchor.left - _Metrics.gap - _Metrics.arrow - width;
        final minTop = insets.top + margin;
        final maxTop = screen.height - insets.bottom - margin - height;
        final t = (anchor.center.dy - height / 2).clamp(
          minTop,
          maxTop < minTop ? minTop : maxTop,
        );
        top = t;
        bottom = null;
        pointerAt = Alignment.topRight;
        pointerOffset = (anchor.center.dy - t - _Pointer.span / 2).clamp(
          AppSpace.sm,
          height - AppSpace.sm - _Pointer.span,
        );
        origin = Alignment(
          1,
          ((anchor.center.dy - t) / height * 2 - 1).clamp(-1.0, 1.0),
        );
    }

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          bottom: bottom,
          width: width,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1),
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: ((t - 0.9) * 10).clamp(0.0, 1.0),
              child: Transform.scale(scale: t, alignment: origin, child: child),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _Bubble<T>(ios: metrics.ios, items: items, onPick: onPick),
                  _Pointer(
                    side: side,
                    corner: pointerAt,
                    offset: pointerOffset,
                    fill: _tint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble<T> extends StatelessWidget {
  const _Bubble({required this.ios, required this.items, required this.onPick});
  final bool ios;
  final List<BubbleMenuItem<T>> items;
  final ValueChanged<T> onPick;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [_tint, AppColors.card],
      ),
      borderRadius: BorderRadius.circular(
        ios ? AppRadius.card : AppRadius.sheet,
      ),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 28,
          spreadRadius: -4,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(
        ios ? AppRadius.card : AppRadius.sheet,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ios ? AppSpace.xs : _Metrics.androidPad,
          horizontal: ios ? 0 : AppSpace.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0 && ios)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: AppSpace.sm,
                  endIndent: AppSpace.sm,
                  color: AppColors.border,
                ),
              _Row<T>(
                ios: ios,
                item: items[i],
                onTap: () => onPick(items[i].value),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _Row<T> extends StatelessWidget {
  const _Row({required this.ios, required this.item, required this.onTap});
  final bool ios;
  final BubbleMenuItem<T> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = item.subtitle;
    final titleColor = item.danger ? AppColors.danger : AppColors.textPrimary;
    final badgeColor =
        item.iconColor ??
        (item.danger ? AppColors.danger : AppColors.accentText);
    final height = (ios ? 48.0 : 50.0) + (subtitle != null ? 10 : 0);
    return Opacity(
      opacity: item.enabled ? 1 : 0.45,
      child: InkWell(
        onTap: item.enabled ? onTap : null,
        borderRadius: ios ? null : BorderRadius.circular(AppRadius.card),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ios ? AppSpace.md : AppSpace.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: ios ? 28 : 34,
                  height: ios ? 28 : 34,
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    // iOS: rounded square badge; Material: round.
                    borderRadius: BorderRadius.circular(
                      ios ? AppRadius.md : AppRadius.full,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    size: ios ? 16 : 20,
                    color: badgeColor,
                  ),
                ),
                SizedBox(width: ios ? AppSpace.md - 2 : AppSpace.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            (ios
                                    ? AppText.titleSm.semiBold
                                    : AppText.titleSm.medium)
                                .tinted(titleColor),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySm.tinted(
                            item.danger
                                ? AppColors.danger.withValues(alpha: 0.7)
                                : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (ios)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The pointer on the menu's edge that faces the button.
class _Pointer extends StatelessWidget {
  const _Pointer({
    required this.side,
    required this.corner,
    required this.offset,
    required this.fill,
  });
  final _Side side;
  final Alignment corner;
  final double offset;
  final Color fill;

  static const double span = 22;

  @override
  Widget build(BuildContext context) {
    const depth = _Metrics.arrow;
    final size = side == _Side.left
        ? const Size(depth, span)
        : const Size(span, depth);
    final paint = CustomPaint(
      size: size,
      painter: _PointerPainter(
        side: side,
        fill: fill,
        stroke: AppColors.border,
      ),
    );
    return switch (side) {
      _Side.below => Positioned(top: -depth + 1, left: offset, child: paint),
      _Side.above => Positioned(bottom: -depth + 1, left: offset, child: paint),
      _Side.left => Positioned(right: -depth + 1, top: offset, child: paint),
    };
  }
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter({
    required this.side,
    required this.fill,
    required this.stroke,
  });
  final _Side side;
  final Color fill, stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = switch (side) {
      _Side.below =>
        (Path()
          ..moveTo(0, h)
          ..lineTo(w / 2, 0)
          ..lineTo(w, h)),
      _Side.above =>
        (Path()
          ..moveTo(0, 0)
          ..lineTo(w / 2, h)
          ..lineTo(w, 0)),
      _Side.left =>
        (Path()
          ..moveTo(0, 0)
          ..lineTo(w, h / 2)
          ..lineTo(0, h)),
    };
    canvas.drawPath(Path.from(path)..close(), Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = stroke,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter old) =>
      old.side != side || old.fill != fill || old.stroke != stroke;
}
