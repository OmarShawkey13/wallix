import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/primary/conditional_builder.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_item.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_item_loading.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomeGetCategoriesLoadingState ||
          state is HomeGetCategoriesSuccessState ||
          state is HomeGetCategoriesErrorState,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            homeCubit.getCategories();
          },
          child: ConditionalBuilder(
            isLoading: state is HomeGetCategoriesLoadingState,
            condition: homeCubit.categories.isNotEmpty,
            builder: (_) => const CategoryItem(),
            fallback: (_) => Center(
              child: Text(appTranslation().get('no_categories')),
            ),
            defaultLoading: const CategoryItemLoading(),
          ),
        );
      },
    );
  }
}
