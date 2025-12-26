import 'package:flutter/material.dart';

class ConditionalBuilder extends StatelessWidget {
  final bool isLoading;
  final bool condition;

  final WidgetBuilder builder;
  final WidgetBuilder? loading;
  final WidgetBuilder? fallback;
  final Widget defaultLoading;

  const ConditionalBuilder({
    super.key,
    required this.isLoading,
    required this.condition,
    required this.builder,
    this.loading,
    this.fallback,
    this.defaultLoading = const Center(
      child: CircularProgressIndicator(),
    ),
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loading?.call(context) ?? defaultLoading;
    }

    if (condition) {
      return builder(context);
    }

    return fallback?.call(context) ?? const SizedBox.shrink();
  }
}
