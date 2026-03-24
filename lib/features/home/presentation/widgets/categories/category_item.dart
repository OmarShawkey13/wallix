import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_card.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_wallpapers_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: homeCubit.categories.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final category = homeCubit.categories[index];
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) => current is HomeScaleUpdatedState,
          builder: (context, state) {
            return CategoryCard(
              title: category.displayName,
              imageUrl: category.thumbnail,
              count: category.imageCount,
              isPressed: homeCubit.scaledIndex == index,
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
            );
          },
        );
      },
    );
  }
}
