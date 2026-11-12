import 'dart:io';

import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

class MedicineImage extends StatelessWidget {
  const MedicineImage({
    super.key,
    required this.path,
    this.size,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.lg,
  });
  final String? path;
  final double? size;
  final BoxFit fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: AppColors.inset,
      child: Icon(Icons.medication_outlined, color: AppColors.textMuted),
    );
    final p = path;
    final hasFile = p != null && p.isNotEmpty && File(p).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: !hasFile
          ? placeholder
          : Image.file(
              File(p),
              width: size,
              height: size,
              fit: fit,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}
