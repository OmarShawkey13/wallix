import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) => current is HomeScaleUpdatedState,
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.0,
            mainAxisSpacing: 14.0,
            childAspectRatio: 0.65,
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
                      images: homeCubit.favorites
                          .map((e) => e.urlImage)
                          .toList(),
                      initialIndex: index,
                      isFromFavorites: true,
                    ),
                  ),
                );
              },
              onTapCancel: homeCubit.onTapCancelItem,
              child: AnimatedScale(
                scale: isPressed ? 0.94 : 1.0,
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOut,
                child: Hero(
                  tag: '${wallpaper.urlImage}_$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        wallpaper.urlImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: ColorsManager.cardColor,
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
