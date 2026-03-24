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
import 'package:wallix/core/network/local/sqflite_helper.dart';
import 'package:wallix/core/network/remote/api_endpoints.dart';
import 'package:wallix/core/network/remote/dio_helper.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';

import 'package:wallix/features/home/presentation/widgets/categories_screen.dart';
import 'package:wallix/features/home/presentation/widgets/favorites_screen.dart';
import 'package:wallix/features/home/presentation/widgets/settings_screen.dart';
import 'package:wallix/features/home/presentation/widgets/wallpaper_screen.dart';

import 'package:wallix/main.dart';

HomeCubit get homeCubit => HomeCubit.get(navigatorKey.currentContext!);

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  // ================== NAV ==================
  final List<Widget> bottomNavPages = const [
    WallpaperScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    emit(HomeBottomNavIndexUpdatedState());
  }

  // ================== WALLPAPERS ==================
  List<WallpaperModel> allWallpapers = [];
  List<WallpaperModel> wallpapersList = [];

  int _currentPage = 0;
  final int _pageSize = 10;
  bool hasMore = true;

  Future<void> getWallpaperData() async {
    emit(HomeGetWallpaperLoadingState());

    final result = await DioHelper.getData(url: wallpapers);

    result.fold(
      (e) => emit(HomeGetWallpaperErrorState(e)),
      (res) {
        final data = _parse(res.data);
        final List<Map<String, dynamic>> list =
            (data['wallpaper'] as List).cast<Map<String, dynamic>>()..shuffle();

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
    final next = allWallpapers
        .skip(_currentPage * _pageSize)
        .take(_pageSize)
        .toList();

    if (next.isEmpty) {
      hasMore = false;
      return;
    }

    wallpapersList.addAll(next);
    _currentPage++;

    if (wallpapersList.length >= allWallpapers.length) {
      hasMore = false;
    }
  }

  // ================== CATEGORIES ==================
  List<CategoryModel> categories = [];

  Future<void> getCategories() async {
    emit(HomeGetCategoriesLoadingState());

    final result = await DioHelper.getData(url: category);

    result.fold(
      (e) => emit(HomeGetCategoriesErrorState(e)),
      (res) {
        final data = _parse(res.data);
        final List<Map<String, dynamic>> list =
            (data['categories'] as List).cast<Map<String, dynamic>>()
              ..shuffle();

        categories = list.map((e) => CategoryModel.fromJson(e)).toList();

        emit(HomeGetCategoriesSuccessState());
      },
    );
  }

  List<String> getCategoryImages({
    required String categoryName,
    required int count,
  }) => List.generate(
    count,
    (i) =>
        'https://raw.githubusercontent.com/OmarShawkey13/WallPaper/main/$categoryName/${i + 1}.jpg',
  );

  // ================== UI INTERACTIONS ==================
  int? _scaledIndex;

  int? get scaledIndex => _scaledIndex;

  void onTapDownItem(int i) {
    _scaledIndex = i;
    emit(HomeScaleUpdatedState());
  }

  void onTapUpItem() => _resetScale();

  void onTapCancelItem() => _resetScale();

  void _resetScale() {
    _scaledIndex = null;
    emit(HomeScaleUpdatedState());
  }

  // ================== PAGE VIEW ==================
  PageController pageController = PageController();

  int _pageCurrentIndex = 0;

  int get pageCurrentIndex => _pageCurrentIndex;

  set pageCurrentIndex(int i) {
    _pageCurrentIndex = i;
    emit(HomePageCurrentIndexUpdatedState());
  }

  void initPreview(int index) {
    _pageCurrentIndex = index;
    pageController = PageController(initialPage: index);
    emit(HomePageCurrentIndexUpdatedState());
  }

  // ================== FAVORITES ==================
  List<WallpaperModel> favorites = [];
  bool isCurrentWallpaperFavorite = false;

  Future<void> loadFavorites() async {
    emit(HomeFavoritesLoadingState());
    favorites = await SqfliteHelper.getFavorites();
    emit(HomeFavoritesSuccessState());
  }

  Future<void> toggleFavorite(
    String url, {
    bool isFromFavoritesScreen = false,
  }) async {
    final isFav = await SqfliteHelper.isFavorite(url);

    isFav
        ? await SqfliteHelper.deleteFavorite(url)
        : await SqfliteHelper.insertFavorite(
            WallpaperModel(urlImage: url),
          );

    await loadFavorites();

    if (isFromFavoritesScreen &&
        isFav &&
        _pageCurrentIndex >= favorites.length) {
      _pageCurrentIndex = favorites.length - 1;
    }

    await checkFavoriteStatus(url);
  }

  Future<void> checkFavoriteStatus(String url) async {
    isCurrentWallpaperFavorite = await SqfliteHelper.isFavorite(url);
    emit(HomeFavoriteStatusChangedState());
  }

  // ================== DOWNLOAD ==================
  Future<void> downloadWallpaper(String url) async {
    emit(HomeDownloadLoadingState());

    try {
      final path = await _downloadImage(url);
      emit(HomeDownloadSuccessState(path));
    } catch (e) {
      emit(HomeDownloadErrorState(e.toString()));
    }
  }

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

  // ================== HELPERS ==================
  dynamic _parse(dynamic data) => data is String ? jsonDecode(data) : data;

  Future<String> _downloadImage(String url) async {
    await _requestPermissions();
    final dir = await _getDirectory();

    final path = '${dir.path}/${url.split('/').last}';

    final result = await DioHelper.downloadFile(
      url: url,
      savePath: path,
    );

    return result.fold(
      (e) => throw Exception(e),
      (p) async {
        await MediaScanner.loadMedia(path: p);
        return p;
      },
    );
  }

  Future<void> _requestPermissions() async {
    if (!Platform.isAndroid) return;

    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  Future<Directory> _getDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Pictures/Wallix');

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      return dir;
    }

    return await getApplicationDocumentsDirectory();
  }
}
