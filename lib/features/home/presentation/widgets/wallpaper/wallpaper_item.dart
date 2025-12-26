import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class WallpaperItem extends StatelessWidget {
  final ScrollController scrollController;

  const WallpaperItem({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.6,
      ),
      itemCount: homeCubit.wallpapersList.length,
      itemBuilder: (context, index) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) => state is HomeScaleUpdatedState,
          builder: (context, state) {
            final isPressed = homeCubit.scaledIndex == index;
            return GestureDetector(
              onTapDown: (_) => homeCubit.onTapDownItem(index),
              onTapUp: (_) {
                homeCubit.onTapUpItem();
                Navigator.push(
                  context,
                  MaterialPageRoute<Object>(
                    builder: (context) => WallpaperPreviewScreen(
                      images: homeCubit.wallpapersList
                          .map((e) => e.urlImage)
                          .toList(),
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
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    homeCubit.wallpapersList[index].urlImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.error));
                    },
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
