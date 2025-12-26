import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class CategoryWallpapersScreen extends StatelessWidget {
  final String title;
  final List<String> images;

  const CategoryWallpapersScreen({
    super.key,
    required this.title,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop,
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.6,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (_, scale) => scale is HomeScaleUpdatedState,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
