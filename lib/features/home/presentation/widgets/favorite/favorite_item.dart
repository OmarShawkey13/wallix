import 'package:flutter/material.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.6,
      ),
      itemCount: homeCubit.favorites.length,
      itemBuilder: (context, index) {
        final wallpaper = homeCubit.favorites[index];
        final isPressed = homeCubit.scaledIndex == index;
        return GestureDetector(
          onTapDown: (_) => homeCubit.onTapDownItem(index),
          onTapUp: (_) {
            homeCubit.onTapUpItem();
            Navigator.push(
              context,
              MaterialPageRoute<Object>(
                builder: (context) => WallpaperPreviewScreen(
                  images: homeCubit.favorites.map((e) => e.urlImage).toList(),
                  initialIndex: index,
                ),
              ),
            );
          },
          onTapCancel: homeCubit.onTapCancelItem,
          child: AnimatedScale(
            scale: isPressed ? 0.94 : 1.0,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    wallpaper.urlImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
