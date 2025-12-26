import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper/flutter_wallpaper.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallix/core/models/category_model.dart';
import 'package:wallix/core/models/wallpaper_model.dart';
import 'package:wallix/core/network/local/cache_helper.dart';
import 'package:wallix/core/network/local/sqflite_helper.dart';
import 'package:wallix/core/network/remote/api_endpoints.dart';
import 'package:wallix/core/network/remote/dio_helper.dart';
import 'package:wallix/core/utils/constants/translations.dart';
import 'package:wallix/core/utils/cubit/home_state.dart';
import 'package:wallix/features/home/presentation/widgets/categories_screen.dart';
import 'package:wallix/features/home/presentation/widgets/favorites_screen.dart';
import 'package:wallix/features/home/presentation/widgets/settings_screen.dart';
import 'package:wallix/features/home/presentation/widgets/wallpaper_screen.dart';
import 'package:wallix/main.dart';

HomeCubit get homeCubit => HomeCubit.get(navigatorKey.currentContext!);

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void changeTheme({bool? fromShared}) {
    _isDarkMode = fromShared ?? !_isDarkMode;
    CacheHelper.saveData(key: 'isDark', value: _isDarkMode);
    emit(HomeChangeThemeState());
  }

  bool _isArabicLang = false;
  TranslationModel? _translationModel;

  // Getters فقط (لا نسمح لأي كود خارجي يعدل القيمة)
  bool get isArabicLang => _isArabicLang;

  TranslationModel? get translationModel => _translationModel;

  /// تغيير اللغة — الدالة الرسمية الوحيدة
  Future<void> changeLanguage({
    required bool isArabic,
    required String translations,
  }) async {
    try {
      if (_isArabicLang == isArabic && _translationModel != null) {
        emit(HomeLanguageUpdatedState());
        return;
      }
      emit(HomeLanguageLoadingState());
      final model = TranslationModel.fromJson(json.decode(translations));
      _isArabicLang = isArabic;
      _translationModel = model;
      emit(HomeLanguageUpdatedState());
    } catch (e) {
      emit(HomeLanguageErrorState(e.toString()));
    }
  }

  Future<void> initializeLanguage({
    required bool isArabic,
    required String translations,
  }) async {
    try {
      _isArabicLang = isArabic;
      _translationModel = TranslationModel.fromJson(json.decode(translations));
      emit(HomeLanguageSuccessState());
    } catch (e) {
      emit(HomeLanguageErrorState(e.toString()));
    }
  }

  //bottomNav
  List<Widget> bottomNavPages = [
    const WallpaperScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    emit(HomeBottomNavIndexUpdatedState());
  }

  //getWallpaper
  List<WallpaperModel> allWallpapers = [];
  List<WallpaperModel> wallpapersList = [];

  int _currentPage = 0;
  final int _pageSize = 10;
  bool hasMore = true;

  Future<void> getWallpaperData() async {
    emit(HomeGetWallpaperLoadingState());
    final result = await DioHelper.getData(url: wallpapers);
    result.fold(
      (error) {
        debugPrint(error.toString());
        emit(HomeGetWallpaperErrorState(error));
      },
      (response) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final List list = data['wallpaper'];
        list.shuffle();

        allWallpapers = list.map((e) => WallpaperModel.fromJson(e)).toList();

        _resetPagination();
        emit(HomeGetWallpaperSuccessState());
      },
    );
  }

  void loadMoreWallpapers() {
    if (!hasMore) return;
    _loadNextPage();
    emit(HomeGetWallpaperSuccessState());
  }

  void _resetPagination() {
    _currentPage = 0;
    wallpapersList.clear();
    hasMore = true;
    _loadNextPage();
  }

  void _loadNextPage() {
    final nextItems = allWallpapers
        .skip(_currentPage * _pageSize)
        .take(_pageSize)
        .toList();

    if (nextItems.isEmpty) {
      hasMore = false;
      return;
    }

    wallpapersList.addAll(nextItems);
    _currentPage++;

    if (wallpapersList.length >= allWallpapers.length) {
      hasMore = false;
    }
  }

  //categories
  List<CategoryModel> categories = [];

  Future<void> getCategories() async {
    emit(HomeGetCategoriesLoadingState());

    final result = await DioHelper.getData(url: category);

    result.fold(
      (error) {
        emit(HomeGetCategoriesErrorState(error));
      },
      (response) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final List list = data['categories'];
        list.shuffle();

        categories = list.map((e) => CategoryModel.fromJson(e)).toList();

        emit(HomeGetCategoriesSuccessState());
      },
    );
  }

  List<String> getCategoryImages({
    required String categoryName,
    required int count,
  }) {
    return List.generate(
      count,
      (index) =>
          'https://raw.githubusercontent.com/OmarShawkey13/WallPaper/main/$categoryName/${index + 1}.jpg',
    );
  }

  //scale
  int? _scaledIndex;

  int? get scaledIndex => _scaledIndex;

  void onTapDownItem(int index) {
    _scaledIndex = index;
    emit(HomeScaleUpdatedState());
  }

  void onTapUpItem() {
    _scaledIndex = null;
    emit(HomeScaleUpdatedState());
  }

  void onTapCancelItem() {
    _scaledIndex = null;
    emit(HomeScaleUpdatedState());
  }

  //imagePreview
  PageController pageController = PageController();

  int _pageCurrentIndex = 0;

  int get pageCurrentIndex => _pageCurrentIndex;

  set pageCurrentIndex(int index) {
    _pageCurrentIndex = index;
    emit(HomePageCurrentIndexUpdatedState());
  }

  void initPreview(int initialIndex) {
    _pageCurrentIndex = initialIndex;
    pageController = PageController(initialPage: initialIndex);
    emit(HomePageCurrentIndexUpdatedState());
  }

  //favorites
  List<WallpaperModel> favorites = [];
  bool isCurrentWallpaperFavorite = false;

  Future<void> loadFavorites() async {
    emit(HomeFavoritesLoadingState());
    favorites = await SqfliteHelper.getFavorites();
    emit(HomeFavoritesSuccessState());
  }

  Future<void> toggleFavorite(String urlImage) async {
    final isFav = await SqfliteHelper.isFavorite(urlImage);

    if (isFav) {
      await SqfliteHelper.deleteFavorite(urlImage);
    } else {
      await SqfliteHelper.insertFavorite(
        WallpaperModel(urlImage: urlImage),
      );
    }

    await loadFavorites();

    // ✅ لو مفيش Favorites خلاص → اقفل Preview
    if (favorites.isEmpty) {
      emit(HomeFavoritesEmptyState());
      return;
    }

    // ✅ تأمين الـ index
    if (pageCurrentIndex >= favorites.length) {
      pageCurrentIndex = favorites.length - 1;
    }

    await checkFavoriteStatus(favorites[pageCurrentIndex].urlImage);
  }

  Future<void> checkFavoriteStatus(String urlImage) async {
    isCurrentWallpaperFavorite = await SqfliteHelper.isFavorite(urlImage);
    emit(HomeFavoriteStatusChangedState());
  }

  //download
  Future<void> _requestStoragePermissions() async {
    if (!Platform.isAndroid) return;

    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<Directory> _getWallixDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Pictures/Wallix');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory;
    }

    return await getApplicationDocumentsDirectory();
  }

  Future<String> _downloadImage(String url) async {
    await _requestStoragePermissions();
    final directory = await _getWallixDirectory();

    final fileName = url.split('/').last;
    final savePath = '${directory.path}/$fileName';

    final result = await DioHelper.downloadFile(
      url: url,
      savePath: savePath,
    );

    return result.fold(
      (error) => throw Exception(error),
      (path) async {
        await MediaScanner.loadMedia(path: path);
        return path;
      },
    );
  }

  Future<void> downloadWallpaper(String url) async {
    emit(HomeDownloadLoadingState());

    try {
      final path = await _downloadImage(url);
      emit(HomeDownloadSuccessState(path));
    } catch (e) {
      emit(HomeDownloadErrorState(e.toString()));
    }
  }

  //wallpaper
  Future<void> setWallpaper(String url, int location) async {
    emit(HomeSetWallpaperLoadingState());

    try {
      final path = await _downloadImage(url);

      await WallpaperManager.setWallpaperFromFile(
        path,
        location,
      );

      emit(HomeSetWallpaperSuccessState());
    } catch (e) {
      emit(HomeSetWallpaperErrorState(e.toString()));
    }
  }
}
