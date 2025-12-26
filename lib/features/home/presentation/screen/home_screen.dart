import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/utils/constants/assets_helper.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomeBottomNavIndexUpdatedState ||
          state is HomeChangeThemeState ||
          state is HomeLanguageUpdatedState ||
          state is HomeLanguageSuccessState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 6,
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(AssetsHelper.logo),
                  backgroundColor: Color(0xff0c011d),
                ),
                Text(appTranslation().get('app_name')),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => homeCubit.changeTheme(),
                icon: Icon(
                  homeCubit.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: homeCubit.currentIndex,
            children: homeCubit.bottomNavPages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeCubit.currentIndex,
            onTap: (index) => homeCubit.currentIndex = index,
            items: [
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AssetsHelper.icHome),
                ),
                label: appTranslation().get('home'),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AssetsHelper.icCategory),
                ),
                label: appTranslation().get('category'),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AssetsHelper.icFavorite),
                ),
                label: appTranslation().get('favorite'),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AssetsHelper.icSettings),
                ),
                label: appTranslation().get('settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}
