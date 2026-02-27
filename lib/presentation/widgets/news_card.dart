// lib/presentation/widgets/news_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/article_entity.dart';
import '../providers/app_providers.dart';

// ─── Featured/Carousel Card ──────────────────────────────────────────────────

class FeaturedNewsCard extends ConsumerWidget {
  final ArticleEntity article;

  const FeaturedNewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/article', extra: article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              _buildImage(article.imageUrl),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.2, 0.5, 1.0],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.category != null)
                        _CategoryBadge(category: article.category!),
                      const SizedBox(height: 6),
                      Text(
                        article.title ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                const Shadow(blurRadius: 4, color: Colors.black54),
                              ],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.source_rounded,
                              size: 12, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            article.sourceName ?? 'Unknown',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                          const Spacer(),
                          Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            AppUtils.timeAgo(article.publishedAt),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Video indicator
              if (article.hasVideo)
                const Positioned(
                  top: 12,
                  right: 12,
                  child: _VideoIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: AppColors.cardDark,
        child: const Center(
          child: Icon(Icons.image_outlined, size: 48, color: Colors.white30),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(
        color: AppColors.cardDark,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.white30),
        ),
      ),
    );
  }
}

// ─── Standard News Card (full card with image on top) ────────────────────────

class NewsCard extends ConsumerWidget {
  final ArticleEntity article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/article', extra: article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(article.imageUrl),
                    if (article.hasVideo) const _VideoIndicatorOverlay(),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (article.category != null)
                          _CategoryBadge(category: article.category!),
                        const Spacer(),
                        _BookmarkButton(article: article),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (article.description != null)
                      Text(
                        article.description!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 10),
                    _MetaRow(article: article),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: Colors.grey[200]),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }
}

// ─── Compact List Card (thumbnail + text) ────────────────────────────────────

class CompactNewsCard extends ConsumerWidget {
  final ArticleEntity article;

  const CompactNewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/article', extra: article),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    article.hasImage
                        ? CachedNetworkImage(
                            imageUrl: article.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.grey[300]),
                            errorWidget: (_, __, ___) =>
                                Container(color: Colors.grey[300]),
                          )
                        : Container(
                            color: isDark ? AppColors.cardDark : Colors.grey[200],
                            child: const Icon(Icons.newspaper, color: Colors.grey),
                          ),
                    if (article.hasVideo)
                      Container(
                        color: Colors.black38,
                        child: const Center(
                          child: Icon(Icons.play_circle_fill_rounded,
                              color: Colors.white, size: 28),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null)
                    Text(
                      article.sourceName!.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    article.title ?? '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppUtils.timeAgo(article.publishedAt),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ──────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getCategoryColor(category).withOpacity(0.3),
        ),
      ),
      child: Text(
        category.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getCategoryColor(category),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return AppColors.techColor;
      case 'sports':
        return AppColors.sportsColor;
      case 'business':
        return AppColors.businessColor;
      case 'health':
        return AppColors.healthColor;
      case 'science':
        return AppColors.scienceColor;
      case 'entertainment':
        return AppColors.entColor;
      default:
        return AppColors.generalColor;
    }
  }
}

class _BookmarkButton extends ConsumerWidget {
  final ArticleEntity article;

  const _BookmarkButton({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksNotifier = ref.watch(bookmarksProvider.notifier);
    final isBookmarked = bookmarksNotifier.isBookmarked(article.uniqueId);

    return GestureDetector(
      onTap: () async {
        await ref.read(bookmarksProvider.notifier).toggleBookmark(article);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          key: ValueKey(isBookmarked),
          color: isBookmarked
              ? AppColors.accent
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          size: 22,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final ArticleEntity article;

  const _MetaRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (article.sourceName != null) ...[
          Icon(Icons.source_rounded,
              size: 12,
              color: theme.textTheme.bodySmall?.color),
          const SizedBox(width: 4),
          Text(
            article.sourceName!,
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(width: 10),
        ],
        Icon(Icons.access_time_rounded,
            size: 12, color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(
          AppUtils.timeAgo(article.publishedAt),
          style: theme.textTheme.labelSmall,
        ),
        const Spacer(),
        Text(
          AppUtils.formatReadTime(article.content),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _VideoIndicator extends StatelessWidget {
  const _VideoIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red[700],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
          SizedBox(width: 2),
          Text(
            'VIDEO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoIndicatorOverlay extends StatelessWidget {
  const _VideoIndicatorOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}
