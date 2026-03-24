import 'package:flutter/material.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/wallpaper_card.dart';

class WallpaperPager extends StatelessWidget {
  final List<String> images;

  const WallpaperPager({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.65,
      child: PageView.builder(
        controller: homeCubit.pageController,
        itemCount: images.length,
        clipBehavior: Clip.none,
        onPageChanged: (page) => homeCubit.pageCurrentIndex = page,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: homeCubit.pageController,
            builder: (context, child) {
              double value = 1.0;
              if (homeCubit.pageController.position.hasContentDimensions) {
                value = homeCubit.pageController.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
              } else {
                value = index == homeCubit.pageCurrentIndex ? 1.0 : 0.8;
              }
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: WallpaperCard(
              imageUrl: images[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}
