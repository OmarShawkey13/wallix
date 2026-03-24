import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/blurred_background.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/preview_back_button.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/set_wallpaper_bottom_sheet.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/wallpaper_action_bar.dart';
import 'package:wallix/features/wallpaper_preview/presentation/widgets/wallpaper_pager.dart';

class WallpaperPreviewScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final bool isFromFavorites;

  const WallpaperPreviewScreen({
    super.key,
    required this.images,
    required this.initialIndex,
    this.isFromFavorites = false,
  });

  @override
  State<WallpaperPreviewScreen> createState() => _WallpaperPreviewScreenState();
}

class _WallpaperPreviewScreenState extends State<WallpaperPreviewScreen> {
  late List<String> currentImages;

  @override
  void initState() {
    super.initState();
    currentImages = List.from(widget.images);
    homeCubit.initPreview(widget.initialIndex);
    if (currentImages.isNotEmpty) {
      homeCubit.checkFavoriteStatus(currentImages[widget.initialIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeFavoritesEmptyState && widget.isFromFavorites) {
          context.pop;
        }

        if (state is HomeFavoritesSuccessState && widget.isFromFavorites) {
          setState(() {
            currentImages = homeCubit.favorites.map((e) => e.urlImage).toList();
          });

          if (currentImages.isEmpty) {
            context.pop;
          } else {
            // التأكد من أن الـ index الحالي لا يزال صالحاً بعد الحذف
            if (homeCubit.pageCurrentIndex >= currentImages.length) {
              homeCubit.pageCurrentIndex = currentImages.length - 1;
            }
            homeCubit.checkFavoriteStatus(
              currentImages[homeCubit.pageCurrentIndex],
            );
          }
        }

        if (state is HomePageCurrentIndexUpdatedState) {
          if (homeCubit.pageCurrentIndex < currentImages.length) {
            homeCubit.checkFavoriteStatus(
              currentImages[homeCubit.pageCurrentIndex],
            );
          }
        }

        // Handling other states (Download, Set Wallpaper)
        _handleGlobalStates(context, state);
      },
      buildWhen: (previous, current) =>
          current is HomePageCurrentIndexUpdatedState ||
          current is HomeFavoriteStatusChangedState ||
          current is HomeFavoritesSuccessState,
      builder: (context, state) {
        if (currentImages.isEmpty ||
            homeCubit.pageCurrentIndex < 0 ||
            homeCubit.pageCurrentIndex >= currentImages.length) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentIndex = homeCubit.pageCurrentIndex;
        final currentImage = currentImages[currentIndex];

        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              BlurredBackground(
                imageUrl: currentImage,
                index: currentIndex,
              ),
              WallpaperPager(
                images: currentImages,
              ),
              const PreviewBackButton(),
              WallpaperActionBar(
                onDownload: () => homeCubit.downloadWallpaper(currentImage),
                onFavorite: () => homeCubit.toggleFavorite(
                  currentImage,
                  isFromFavoritesScreen: widget.isFromFavorites,
                ),
                onMore: () => _showWallpaperOptions(context, currentImage),
                isFavorite: homeCubit.isCurrentWallpaperFavorite,
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleGlobalStates(BuildContext context, HomeStates state) {
    if (state is HomeDownloadLoadingState) {
      _showSnackBar(context, appTranslation().get('downloading'));
    } else if (state is HomeDownloadSuccessState) {
      _showSnackBar(
        context,
        '${appTranslation().get('downloaded_to')} ${state.path}',
      );
    } else if (state is HomeDownloadErrorState) {
      _showSnackBar(
        context,
        '${appTranslation().get('download_error')} ${state.error}',
      );
    } else if (state is HomeSetWallpaperLoadingState) {
      _showSnackBar(context, appTranslation().get('setting_wallpaper'));
    } else if (state is HomeSetWallpaperSuccessState) {
      _showSnackBar(
        context,
        appTranslation().get('wallpaper_set_successfully'),
      );
    } else if (state is HomeSetWallpaperErrorState) {
      _showSnackBar(
        context,
        '${appTranslation().get('wallpaper_set_error')} ${state.error}',
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showWallpaperOptions(BuildContext context, String imageUrl) {
    showModalBottomSheet<Object>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true,
      builder: (_) => SetWallpaperBottomSheet(imageUrl: imageUrl),
    );
  }
}
