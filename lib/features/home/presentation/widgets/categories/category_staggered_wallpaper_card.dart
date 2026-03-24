import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class CategoryStaggeredWallpaperCard extends StatelessWidget {
  final int index;
  final List<String> images;

  const CategoryStaggeredWallpaperCard({
    super.key,
    required this.index,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = images[index];
    final double height = (index % 3 == 0)
        ? 280
        : (index % 2 == 0)
        ? 220
        : 250;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index % 10 * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (_, state) => state is HomeScaleUpdatedState,
        builder: (context, state) {
          final isPressed = homeCubit.scaledIndex == index;

          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 14),
            child: GestureDetector(
              onTapDown: (_) => homeCubit.onTapDownItem(index),
              onTapUp: (_) {
                homeCubit.onTapUpItem();
                Navigator.push(
                  context,
                  MaterialPageRoute<Object>(
                    builder: (context) => WallpaperPreviewScreen(
                      images: images,
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
                child: Hero(
                  tag: '${imageUrl}_$index',
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: ColorsManager.cardColor,
                                child: const Center(
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: ColorsManager.cardColor,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
