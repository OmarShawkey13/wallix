import 'package:flutter/material.dart';

class ActionBarItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const ActionBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: icon,
      ),
    );
  }
}
