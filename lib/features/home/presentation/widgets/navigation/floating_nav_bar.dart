import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/constants/assets_helper.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/core/utils/cubit/theme/theme_cubit.dart';
import 'package:wallix/core/utils/cubit/theme/theme_state.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (_, state) => state is HomeBottomNavIndexUpdatedState,
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 24,
                  end: 24,
                  bottom: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: ColorsManager.backgroundColor.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: ColorsManager.isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            index: 0,
                            assetPath: AssetsHelper.icHome,
                            label: appTranslation().get('home'),
                          ),
                          _NavItem(
                            index: 1,
                            assetPath: AssetsHelper.icCategory,
                            label: appTranslation().get('category'),
                          ),
                          _NavItem(
                            index: 2,
                            assetPath: AssetsHelper.icFavorite,
                            label: appTranslation().get('favorite'),
                          ),
                          _NavItem(
                            index: 3,
                            assetPath: AssetsHelper.icSettings,
                            label: appTranslation().get('settings'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final String assetPath;
  final String label;

  const _NavItem({
    required this.index,
    required this.assetPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = homeCubit.currentIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => homeCubit.currentIndex = index,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? ColorsManager.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ImageIcon(
                AssetImage(assetPath),
                color: isSelected
                    ? Colors.white
                    : ColorsManager.iconSecondaryColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? ColorsManager.primary
                    : ColorsManager.iconSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
