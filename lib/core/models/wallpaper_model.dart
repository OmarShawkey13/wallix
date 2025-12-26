class WallpaperModel {
  final String urlImage;

  WallpaperModel({
    required this.urlImage,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      urlImage: json['urlImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urlImage': urlImage,
    };
  }

  factory WallpaperModel.fromDatabase(Map<String, dynamic> map) {
    return WallpaperModel(
      urlImage: map['urlImage'],
    );
  }
}
