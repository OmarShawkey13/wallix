import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/theme/text_styles.dart';
import 'package:wallix/core/utils/constants/assets_helper.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/core/utils/cubit/theme/theme_cubit.dart';
import 'package:wallix/core/utils/cubit/theme/theme_state.dart';
import 'package:wallix/features/home/presentation/widgets/navigation/floating_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) => state is HomeBottomNavIndexUpdatedState,
          builder: (context, state) {
            return Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorsManager.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage(AssetsHelper.logo),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    horizontalSpace10,
                    Text(
                      appTranslation().get('app_name'),
                      style: TextStylesManager.bold18.copyWith(
                        color: ColorsManager.textColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => themeCubit.changeTheme(),
                    style: IconButton.styleFrom(
                      backgroundColor: ColorsManager.cardColor.withValues(
                        alpha: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      themeCubit.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: ColorsManager.primary,
                      size: 20,
                    ),
                  ),
                  horizontalSpace8,
                ],
              ),
              body: IndexedStack(
                index: homeCubit.currentIndex,
                children: homeCubit.bottomNavPages,
              ),
              bottomNavigationBar: const FloatingNavBar(),
            );
          },
        );
      },
    );
  }
}
