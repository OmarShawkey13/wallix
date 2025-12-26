import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/text_styles.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_wallpapers_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: homeCubit.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final category = homeCubit.categories[index];
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) => current is HomeScaleUpdatedState,
          builder: (context, state) {
            return _CategoryCard(
              title: category.displayName,
              imageUrl: category.thumbnail,
              count: category.imageCount,
              onTapDown: (_) => homeCubit.onTapDownItem(index),
              onTapUp: (_) {
                homeCubit.onTapUpItem();
                final images = homeCubit.getCategoryImages(
                  categoryName: category.name,
                  count: category.imageCount,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute<Object>(
                    builder: (_) => CategoryWallpapersScreen(
                      title: category.displayName,
                      images: images,
                    ),
                  ),
                );
              },
              onTapCancel: homeCubit.onTapCancelItem,
              isPressed: homeCubit.scaledIndex == index,
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int count;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final bool isPressed;

  const _CategoryCard({
    required this.title,
    required this.imageUrl,
    required this.count,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        scale: isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStylesManager.bold18.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count Wallpapers',
                      style: TextStylesManager.regular12.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
