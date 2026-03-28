import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/theme/text_styles.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/spacing.dart';

class WallpaperActionBar extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onFavorite;
  final VoidCallback onMore;
  final bool isFavorite;

  const WallpaperActionBar({
    super.key,
    required this.onDownload,
    required this.onFavorite,
    required this.onMore,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildCircularButton(
                  onTap: onFavorite,
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.redAccent : Colors.white,
                ),
                horizontalSpace12,
                Expanded(
                  child: _buildMainAction(
                    onTap: onDownload,
                    icon: Icons.file_download_outlined,
                    label: appTranslation().get('download'),
                  ),
                ),
                horizontalSpace12,
                _buildCircularButton(
                  onTap: onMore,
                  icon: Icons.auto_awesome_mosaic_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }

  Widget _buildMainAction({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                ColorsManager.primary,
                ColorsManager.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              horizontalSpace8,
              Text(
                label,
                style: TextStylesManager.bold16.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
