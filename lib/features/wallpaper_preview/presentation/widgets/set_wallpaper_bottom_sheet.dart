import 'dart:ui';
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
      decoration: BoxDecoration(
        color: ColorsManager.isDark ? const Color(0xFF1C1B1F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpace12,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColorsManager.outlineColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          verticalSpace24,
          Text(
            appTranslation().get('set_wallpaper'),
            style: TextStylesManager.bold20,
          ),
          verticalSpace24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _SheetItem(
                  icon: Icons.home_rounded,
                  title: appTranslation().get('set_home_screen'),
                  onTap: () {
                    context.pop;
                    homeCubit.setWallpaper(imageUrl, WallpaperManager.homeScreen);
                  },
                ),
                verticalSpace12,
                _SheetItem(
                  icon: Icons.lock_rounded,
                  title: appTranslation().get('set_lock_screen'),
                  onTap: () {
                    context.pop;
                    homeCubit.setWallpaper(imageUrl, WallpaperManager.lockScreen);
                  },
                ),
                verticalSpace12,
                _SheetItem(
                  icon: Icons.phonelink_setup_rounded,
                  title: appTranslation().get('set_both_screens'),
                  onTap: () {
                    context.pop;
                    homeCubit.setWallpaper(imageUrl, WallpaperManager.bothScreen);
                  },
                ),
              ],
            ),
          ),
          verticalSpace40,
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
    final isDark = ColorsManager.isDark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ColorsManager.outlineColor.withValues(alpha: 0.1),
            ),
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: ColorsManager.primary, size: 24),
              ),
              horizontalSpace16,
              Expanded(
                child: Text(
                  title,
                  style: TextStylesManager.medium16,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: ColorsManager.outlineColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
