import 'package:flutter/material.dart';

/// Whether to draw the iPhone look: true on iOS, Material otherwise.
bool isIosStyle(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS;
