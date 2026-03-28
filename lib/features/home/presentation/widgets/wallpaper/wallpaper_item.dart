import 'package:flutter/material.dart';
import 'package:wallix/core/utils/constants/primary/staggered_grid.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';

class WallpaperItem extends StatelessWidget {
  final ScrollController scrollController;

  const WallpaperItem({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return CustomStaggeredGrid(
      images: homeCubit.wallpapersList.map((e) => e.urlImage).toList(),
      scrollController: scrollController,
    );
  }
}
