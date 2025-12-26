abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeThemeState extends HomeStates {}

class HomeLanguageUpdatedState extends HomeStates {}

class HomeLanguageLoadingState extends HomeStates {}

class HomeLanguageSuccessState extends HomeStates {}

class HomeLanguageErrorState extends HomeStates {
  final String error;

  HomeLanguageErrorState(this.error);
}

//bottomNav
class HomeBottomNavIndexUpdatedState extends HomeStates {}

//getWallpaper
class HomeGetWallpaperLoadingState extends HomeStates {}

class HomeGetWallpaperSuccessState extends HomeStates {}

class HomeGetWallpaperErrorState extends HomeStates {
  final String error;

  HomeGetWallpaperErrorState(this.error);
}

//getCategories
class HomeGetCategoriesLoadingState extends HomeStates {}

class HomeGetCategoriesSuccessState extends HomeStates {}

class HomeGetCategoriesErrorState extends HomeStates {
  final String error;

  HomeGetCategoriesErrorState(this.error);
}

//scale
class HomeScaleUpdatedState extends HomeStates {}

//imagePreview
class HomePageCurrentIndexUpdatedState extends HomeStates {}

//favorites
class HomeFavoritesLoadingState extends HomeStates {}

class HomeFavoritesSuccessState extends HomeStates {}

class HomeFavoritesEmptyState extends HomeStates {}

class HomeFavoriteStatusChangedState extends HomeStates {}
