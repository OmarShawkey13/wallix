import 'package:flutter/material.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';
import 'package:wallix/features/home/presentation/widgets/categories/category_staggered_wallpaper_card.dart';

class CategoryWallpapersScreen extends StatelessWidget {
  final String title;
  final List<String> images;

  const CategoryWallpapersScreen({
    super.key,
    required this.title,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final leftColumn = <int>[];
    final rightColumn = <int>[];
    for (int i = 0; i < images.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(i);
      } else {
        rightColumn.add(i);
      }
    }

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop,
        ),
        title: Text(title),
        centerTitle: true,
        backgroundColor: ColorsManager.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          end: 16,
          top: 12,
          bottom: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العمود الأيسر
            Expanded(
              child: Column(
                children: leftColumn
                    .map(
                      (index) => CategoryStaggeredWallpaperCard(
                        index: index,
                        images: images,
                      ),
                    )
                    .toList(),
              ),
            ),
            horizontalSpace14,
            // العمود الأيمن
            Expanded(
              child: Column(
                children: rightColumn
                    .map(
                      (index) => CategoryStaggeredWallpaperCard(
                        index: index,
                        images: images,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
