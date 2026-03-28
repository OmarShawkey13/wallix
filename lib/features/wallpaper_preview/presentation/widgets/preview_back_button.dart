import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';

class PreviewBackButton extends StatelessWidget {
  const PreviewBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: MediaQuery.of(context).padding.top + 16,
      start: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => context.pop,
            ),
          ),
        ),
      ),
    );
  }
}
