import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoriteItemLoading extends StatelessWidget {
  const FavoriteItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.6,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Skeleton.leaf(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
