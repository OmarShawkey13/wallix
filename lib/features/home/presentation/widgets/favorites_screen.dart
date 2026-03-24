import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/primary/conditional_builder.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/favorite/favorite_item.dart';
import 'package:wallix/features/home/presentation/widgets/favorite/favorite_item_loading.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomeFavoritesLoadingState ||
          state is HomeFavoritesSuccessState ||
          state is HomeScaleUpdatedState,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            homeCubit.loadFavorites();
          },
          child: ConditionalBuilder(
            isLoading: state is HomeFavoritesLoadingState,
            condition: homeCubit.favorites.isNotEmpty,
            builder: (_) => const FavoriteItem(),
            fallback: (_) => Center(
              child: Text(appTranslation().get('no_favorites')),
            ),
            defaultLoading: const FavoriteItemLoading(),
          ),
        );
      },
    );
  }
}
