import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/blurred_background.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/preview_back_button.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/wallpaper_action_bar.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/wallpaper_pager.dart';

class WallpaperPreviewScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const WallpaperPreviewScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<WallpaperPreviewScreen> createState() => _WallpaperPreviewScreenState();
}

class _WallpaperPreviewScreenState extends State<WallpaperPreviewScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.initPreview(widget.initialIndex);
    if (widget.images.isNotEmpty) {
      homeCubit.checkFavoriteStatus(
        widget.images[widget.initialIndex],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeFavoritesEmptyState) {
          context.pop;
        }
        if (state is HomePageCurrentIndexUpdatedState) {
          homeCubit.checkFavoriteStatus(
            widget.images[homeCubit.pageCurrentIndex],
          );
        }
      },
      buildWhen: (previous, current) =>
          current is HomePageCurrentIndexUpdatedState ||
          current is HomeFavoriteStatusChangedState,
      builder: (context, state) {
        if (widget.images.isEmpty ||
            homeCubit.pageCurrentIndex < 0 ||
            homeCubit.pageCurrentIndex >= widget.images.length) {
          return const SizedBox.shrink();
        }
        final currentIndex = homeCubit.pageCurrentIndex;
        final currentImage = widget.images[currentIndex];
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              BlurredBackground(
                imageUrl: currentImage,
                index: currentIndex,
              ),
              WallpaperPager(
                images: widget.images,
              ),
              const PreviewBackButton(),
              WallpaperActionBar(
                onDownload: () {},
                onFavorite: () {
                  homeCubit.toggleFavorite(currentImage);
                },
                onMore: () {},
                isFavorite: homeCubit.isCurrentWallpaperFavorite,
              ),
            ],
          ),
        );
      },
    );
  }
}
