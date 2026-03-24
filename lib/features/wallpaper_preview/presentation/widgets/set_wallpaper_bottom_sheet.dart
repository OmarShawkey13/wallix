import 'package:flutter/material.dart';
import 'package:flutter_wallpaper/flutter_wallpaper.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/theme/text_styles.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';

class SetWallpaperBottomSheet extends StatelessWidget {
  final String imageUrl;

  const SetWallpaperBottomSheet({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 24,
        end: 24,
        bottom: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              appTranslation().get('set_wallpaper'),
              style: TextStylesManager.bold20,
            ),
          ),
          verticalSpace24,
          _SheetItem(
            icon: Icons.home_outlined,
            title: appTranslation().get('set_home_screen'),
            onTap: () {
              context.pop;
              homeCubit.setWallpaper(
                imageUrl,
                WallpaperManager.homeScreen,
              );
            },
          ),
          verticalSpace12,
          _SheetItem(
            icon: Icons.lock_outline,
            title: appTranslation().get('set_lock_screen'),
            onTap: () {
              context.pop;
              homeCubit.setWallpaper(
                imageUrl,
                WallpaperManager.lockScreen,
              );
            },
          ),
          verticalSpace12,
          _SheetItem(
            icon: Icons.wallpaper_rounded,
            title: appTranslation().get('set_both_screens'),
            onTap: () {
              context.pop;
              homeCubit.setWallpaper(
                imageUrl,
                WallpaperManager.bothScreen,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: ColorsManager.cardColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorsManager.outlineColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorsManager.primary),
            horizontalSpace16,
            Text(
              title,
              style: TextStylesManager.medium16,
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
