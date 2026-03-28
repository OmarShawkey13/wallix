import 'package:flutter/material.dart';
import 'package:wallix/core/utils/constants/primary/staggered_grid.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStaggeredGrid(
      images: homeCubit.favorites.map((e) => e.urlImage).toList(),
      isFromFavorites: true,
      padding: const EdgeInsets.all(16.0),
    );
  }
}
