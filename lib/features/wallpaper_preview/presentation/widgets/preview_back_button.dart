import 'package:flutter/material.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';

class PreviewBackButton extends StatelessWidget {
  const PreviewBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 40,
      start: 20,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () => context.pop,
      ),
    );
  }
}
