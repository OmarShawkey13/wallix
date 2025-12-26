import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wallix/core/utils/constants/assets_helper.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/action_bar_item.dart';

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
      bottom: 24,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionBarItem(
                    onTap: onDownload,
                    label: appTranslation().get('download'),
                    icon: Image.asset(
                      AssetsHelper.icDownload,
                      color: Colors.white,
                      width: 22,
                      height: 22,
                    ),
                  ),
                  ActionBarItem(
                    onTap: onFavorite,
                    label: appTranslation().get('favorite'),
                    icon: isFavorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 22,
                          )
                        : Image.asset(
                            AssetsHelper.icFavorite,
                            color: Colors.white,
                            width: 22,
                            height: 22,
                          ),
                  ),
                  ActionBarItem(
                    onTap: onMore,
                    label: appTranslation().get('more'),
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
