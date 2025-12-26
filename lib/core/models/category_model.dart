class CategoryModel {
  final String name;
  final String displayName;
  final String thumbnail;
  final int imageCount;

  CategoryModel({
    required this.name,
    required this.displayName,
    required this.thumbnail,
    required this.imageCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      displayName: json['displayName'],
      thumbnail: json['thumbnail'],
      imageCount: json['imageCount'],
    );
  }
}
