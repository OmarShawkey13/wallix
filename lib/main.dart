import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/di/injections.dart';
import 'package:wallix/core/network/local/cache_helper.dart';
import 'package:wallix/core/theme/theme.dart';
import 'package:wallix/core/utils/constants/my_bloc_observer.dart';
import 'package:wallix/core/utils/constants/routes.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  Bloc.observer = MyBlocObserver();
  final bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  final bool isArabic = CacheHelper.getData(key: 'isArabicLang') ?? false;
  final String translation = await rootBundle.loadString(
    'assets/translations/${isArabic ? 'ar' : 'en'}.json',
  );
  runApp(
    MyApp(
      isDark: isDark,
      isArabic: isArabic,
      translation: translation,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final bool isArabic;
  final String translation;

  const MyApp({
    super.key,
    required this.isDark,
    required this.isArabic,
    required this.translation,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()
        ..changeTheme(fromShared: isDark)
        ..initializeLanguage(
          isArabic: isArabic,
          translations: translation,
        ),
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            routes: Routes.routes,
            initialRoute: Routes.home,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: HomeCubit.get(context).isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            builder: (context, child) {
              return Directionality(
                textDirection: HomeCubit.get(context).isArabicLang
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
