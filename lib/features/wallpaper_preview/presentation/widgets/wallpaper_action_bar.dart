import 'dart:ui';
import 'package:flutter/material.dart';
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
      bottom: 32,
      left: 24,
      right: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildActionButton(
                  onTap: onFavorite,
                  icon: isFavorite
                      ? const Icon(Icons.favorite, color: Colors.redAccent)
                      : const Icon(Icons.favorite_border, color: Colors.white),
                  label: appTranslation().get('favorite'),
                ),
                horizontalSpace8,
                Expanded(
                  child: GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.tertiary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                            ),
                            horizontalSpace8,
                            Text(
                              appTranslation().get('download'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpace8,
                _buildActionButton(
                  onTap: onMore,
                  icon: const Icon(Icons.tune_rounded, color: Colors.white),
                  label: appTranslation().get('more'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required Widget icon,
    required String label,
  }) {
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
