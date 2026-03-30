import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/theme/text_styles.dart';
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
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final currentIndex = homeCubit.pageCurrentIndex;
        final currentImage = currentImages[currentIndex];

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            alignment: Alignment.center,
            children: [
              // Background Layer
              BlurredBackground(
                imageUrl: currentImage,
                index: currentIndex,
              ),

              // Content Layer
              WallpaperPager(
                images: currentImages,
              ),

              // Top Bar
              const PreviewBackButton(),

              // Bottom Action Bar
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
      _showCustomSnackBar(
        context,
        appTranslation().get('downloading'),
        isLoading: true,
      );
    } else if (state is HomeDownloadSuccessState) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showCustomSnackBar(
        context,
        appTranslation().get('download_success'),
        icon: Icons.check_circle_outline,
        color: ColorsManager.success,
      );
    } else if (state is HomeDownloadErrorState) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showCustomSnackBar(
        context,
        appTranslation().get('download_error'),
        icon: Icons.error_outline,
        color: ColorsManager.error,
      );
    } else if (state is HomeSetWallpaperLoadingState) {
      _showCustomSnackBar(
        context,
        appTranslation().get('setting_wallpaper'),
        isLoading: true,
      );
    } else if (state is HomeSetWallpaperSuccessState) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showCustomSnackBar(
        context,
        appTranslation().get('wallpaper_set_successfully'),
        icon: Icons.wallpaper_rounded,
        color: ColorsManager.success,
      );
    }
  }

  void _showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isLoading = false,
    IconData? icon,
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ColorsManager.isDark
                ? const Color(0xFF2C2C2C)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (icon != null)
                Icon(icon, color: color ?? ColorsManager.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStylesManager.medium14.copyWith(
                    color: ColorsManager.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWallpaperOptions(BuildContext context, String imageUrl) {
    showModalBottomSheet<Object>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SetWallpaperBottomSheet(imageUrl: imageUrl),
    );
  }
}
