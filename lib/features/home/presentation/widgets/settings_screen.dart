import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/constants/constants.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/theme/theme_cubit.dart';
import 'package:wallix/core/utils/cubit/theme/theme_state.dart';
import 'package:wallix/features/home/presentation/widgets/settings/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) =>
          current is ThemeChangeThemeState ||
          current is ThemeLanguageUpdatedState ||
          current is ThemeLanguageSuccessState,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SettingsTile(
                icon: themeCubit.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: appTranslation().get('app_theme'),
                subtitle: themeCubit.isDarkMode
                    ? appTranslation().get('dark_mode')
                    : appTranslation().get('light_mode'),
                trailing: Switch(
                  value: themeCubit.isDarkMode,
                  activeThumbColor: ColorsManager.primary,
                  onChanged: (_) => themeCubit.changeTheme(),
                ),
              ),
              verticalSpace12,
              SettingsTile(
                icon: Icons.language,
                title: appTranslation().get('language'),
                subtitle: themeCubit.isArabicLang ? 'العربية' : 'English',
                trailing: Switch(
                  value: themeCubit.isArabicLang,
                  activeThumbColor: ColorsManager.primary,
                  onChanged: (_) {
                    themeCubit.toggleLanguage();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
