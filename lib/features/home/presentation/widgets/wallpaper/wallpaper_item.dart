import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/wallpaper/staggered_wallpaper_card.dart';

class WallpaperItem extends StatelessWidget {
  final ScrollController scrollController;

  const WallpaperItem({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final wallpapers = homeCubit.wallpapersList;
        final leftColumn = <int>[];
        final rightColumn = <int>[];
        for (int i = 0; i < wallpapers.length; i++) {
          if (i % 2 == 0) {
            leftColumn.add(i);
          } else {
            rightColumn.add(i);
          }
        }
        return SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: leftColumn
                      .map((index) => StaggeredWallpaperCard(index: index))
                      .toList(),
                ),
              ),
              horizontalSpace14,
              Expanded(
                child: Column(
                  children: rightColumn
                      .map((index) => StaggeredWallpaperCard(index: index))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
