import 'package:flutter/material.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
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
      heightFactor: 0.55,
      child: PageView.builder(
        controller: homeCubit.pageController,
        itemCount: images.length,
        onPageChanged: (page) => homeCubit.pageCurrentIndex = page,
        itemBuilder: (context, index) {
          return WallpaperCard(imageUrl: images[index]);
        },
      ),
    );
  }
}
