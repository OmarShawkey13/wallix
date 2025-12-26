import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/primary/conditional_builder.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/wallpaper/wallpaper_item.dart';
import 'package:wallix/features/home/presentation/widgets/wallpaper/wallpaper_item_loading.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeCubit.getWallpaperData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      homeCubit.loadMoreWallpapers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeGetWallpaperLoadingState ||
          current is HomeGetWallpaperSuccessState ||
          current is HomeGetWallpaperErrorState ||
          current is HomeLanguageUpdatedState ||
          current is HomeLanguageSuccessState,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            homeCubit.getWallpaperData();
          },
          child: ConditionalBuilder(
            isLoading: state is HomeGetWallpaperLoadingState,
            condition: homeCubit.wallpapersList.isNotEmpty,
            builder: (context) {
              return WallpaperItem(scrollController: _scrollController);
            },
            defaultLoading: const WallpaperItemLoading(),
            fallback: (context) {
              return Center(
                child: Text(appTranslation().get('no_wallpapers')),
              );
            },
          ),
        );
      },
    );
  }
}
