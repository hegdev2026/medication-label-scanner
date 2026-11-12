import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final msg = message;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (msg != null) ...[
            const SizedBox(height: AppSpace.md),
            Text(msg, style: AppText.bodyMd),
          ],
        ],
      ),
    );
  }
}
