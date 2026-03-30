import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/utils/constants/spacing.dart';
import 'package:wallix/core/utils/cubit/home/home_cubit.dart';
import 'package:wallix/core/utils/cubit/home/home_state.dart';
import 'package:wallix/features/wallpaper_preview/presentation/screen/wallpaper_preview_screen.dart';

class CustomStaggeredGrid extends StatelessWidget {
  final List<String> images;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final void Function(int index)? onTap;
  final bool isFromFavorites;

  const CustomStaggeredGrid({
    super.key,
    required this.images,
    this.scrollController,
    this.padding,
    this.onTap,
    this.isFromFavorites = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> leftIndices = [];
    final List<int> rightIndices = [];
    for (int i = 0; i < images.length; i++) {
      i.isEven ? leftIndices.add(i) : rightIndices.add(i);
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _StaggeredColumn(
              indices: leftIndices,
              images: images,
              onTap: onTap,
              isFromFavorites: isFromFavorites,
            ),
          ),
          horizontalSpace14,
          Expanded(
            child: _StaggeredColumn(
              indices: rightIndices,
              images: images,
              onTap: onTap,
              isFromFavorites: isFromFavorites,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredColumn extends StatelessWidget {
  final List<int> indices;
  final List<String> images;
  final void Function(int index)? onTap;
  final bool isFromFavorites;

  const _StaggeredColumn({
    required this.indices,
    required this.images,
    this.onTap,
    required this.isFromFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: indices
          .map(
            (index) => StaggeredCard(
              key: ValueKey(images[index]),
              index: index,
              imageUrl: images[index],
              images: images,
              onTap: onTap,
              isFromFavorites: isFromFavorites,
            ),
          )
          .toList(),
    );
  }
}

class StaggeredCard extends StatefulWidget {
  final int index;
  final String imageUrl;
  final List<String> images;
  final void Function(int index)? onTap;
  final bool isFromFavorites;

  const StaggeredCard({
    super.key,
    required this.index,
    required this.imageUrl,
    required this.images,
    this.onTap,
    required this.isFromFavorites,
  });

  @override
  State<StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<StaggeredCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.index % 5 * 100)),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> heights = [280, 340, 220, 300, 260];
    final double cardHeight = heights[widget.index % heights.length];

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
        ),
        child: RepaintBoundary(
          child: BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (_, state) => state is HomeScaleUpdatedState,
            builder: (context, state) {
              final isPressed = homeCubit.scaledIndex == widget.index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTapDown: (_) => homeCubit.onTapDownItem(widget.index),
                  onTapUp: (_) {
                    homeCubit.onTapUpItem();
                    if (widget.onTap != null) {
                      widget.onTap!(widget.index);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Object>(
                          builder: (context) => WallpaperPreviewScreen(
                            images: widget.images,
                            initialIndex: widget.index,
                            isFromFavorites: widget.isFromFavorites,
                          ),
                        ),
                      );
                    }
                  },
                  onTapCancel: homeCubit.onTapCancelItem,
                  child: AnimatedScale(
                    scale: isPressed ? 0.96 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Hero(
                      tag: '${widget.imageUrl}_${widget.index}',
                      child: Container(
                        height: cardHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                fit: BoxFit.cover,
                                memCacheWidth: 450,
                                placeholder: (context, url) => Container(
                                  color: ColorsManager.cardColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: ColorsManager.cardColor,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const _GradientOverlay(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.02),
              Colors.black.withValues(alpha: 0.35),
            ],
            stops: const [0.5, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}
