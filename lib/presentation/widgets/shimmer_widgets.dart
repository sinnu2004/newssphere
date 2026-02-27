// lib/presentation/widgets/shimmer_widgets.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerNewsCard extends StatelessWidget {
  const ShimmerNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 80, color: Colors.white,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(height: 16, color: Colors.white,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Container(height: 16, width: double.infinity * 0.8, color: Colors.white,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(height: 12, width: 60, color: Colors.white,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                        const Spacer(),
                        Container(height: 12, width: 50, color: Colors.white,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerCarouselCard extends StatelessWidget {
  const ShimmerCarouselCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 60, color: Colors.white,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(height: 14, color: Colors.white,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(height: 14, width: 180, color: Colors.white,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 80, color: Colors.white,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
