import 'package:flutter/material.dart';
import 'package:flutter_wallpaper/flutter_wallpaper.dart';
import 'package:wallix/core/theme/text_styles.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';

class SetWallpaperBottomSheet extends StatelessWidget {
  final String imageUrl;

  const SetWallpaperBottomSheet({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            appTranslation().get('set_wallpaper'),
            style: TextStylesManager.bold18,
          ),
          verticalSpace12,
          _SheetItem(
            icon: Icons.home,
            title: appTranslation().get('set_home_screen'),
            onTap: () {
              context.pop;
              homeCubit.setWallpaper(
                imageUrl,
                WallpaperManager.homeScreen,
              );
            },
          ),
          _SheetItem(
            icon: Icons.lock,
            title: appTranslation().get('set_lock_screen'),
            onTap: () {
              context.pop;
              homeCubit.setWallpaper(
                imageUrl,
                WallpaperManager.lockScreen,
              );
            },
          ),
          _SheetItem(
            icon: Icons.wallpaper,
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
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
