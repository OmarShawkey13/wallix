import 'package:flutter/material.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/constants/primary/staggered_grid.dart';
import 'package:wallix/core/utils/extensions/context_extension.dart';

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
      body: CustomStaggeredGrid(images: images),
    );
  }
}
