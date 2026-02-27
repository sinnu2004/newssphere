// lib/presentation/screens/article_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/entities/article_entity.dart';
import '../providers/app_providers.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final ArticleEntity article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  ConsumerState<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _videoInitialized = false;
  bool _videoError = false;

  @override
  void initState() {
    super.initState();
    if (widget.article.hasVideo && widget.article.videoUrl != null) {
      _initVideo(widget.article.videoUrl!);
    }
  }

  Future<void> _initVideo(String url) async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.primary.withOpacity(0.3),
        ),
      );
      if (mounted) setState(() => _videoInitialized = true);
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final article = widget.article;
    final bookmarksNotifier = ref.watch(bookmarksProvider.notifier);
    final isBookmarked = bookmarksNotifier.isBookmarked(article.uniqueId);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: article.hasVideo ? 240 : (article.hasImage ? 280 : 0),
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black54
                      : Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  size: 20,
                ),
              ),
            ),
            actions: [
              // Bookmark
              GestureDetector(
                onTap: () =>
                    ref.read(bookmarksProvider.notifier).toggleBookmark(article),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black54
                        : Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isBookmarked ? AppColors.accent : (isDark ? Colors.white : AppColors.textPrimaryLight),
                    size: 20,
                  ),
                ),
              ),
              // Share
              GestureDetector(
                onTap: () {
                  if (article.url != null) {
                    Share.share('${article.title}\n\n${article.url}');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black54
                        : Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: article.hasVideo
                  ? _VideoPlayer(
                      controller: _chewieController,
                      isInitialized: _videoInitialized,
                      hasError: _videoError,
                      thumbnailUrl: article.imageUrl,
                    )
                  : (article.hasImage
                      ? _HeroImage(imageUrl: article.imageUrl!)
                      : null),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source & Category
                  Row(
                    children: [
                      if (article.sourceName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.sourceName!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (article.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.category!.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article.title ?? '',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 24,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta info
                  _MetaInfoRow(article: article),
                  const SizedBox(height: 20),

                  Divider(
                    color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                    height: 1,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Content
                  if (article.content != null) ...[
                    Text(
                      _cleanContent(article.content!),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Read more button
                  if (article.url != null)
                    _ReadMoreButton(url: article.url!),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cleanContent(String content) {
    // Remove [+N chars] suffix from NewsAPI
    return content.replaceAll(RegExp(r'\[.*?\]'), '').trim();
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.cardDark,
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.cardDark,
              child: const Center(
                child: Icon(Icons.broken_image_outlined,
                    color: Colors.white30, size: 48),
              ),
            ),
          ),
          // Bottom gradient for app bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayer extends StatelessWidget {
  final ChewieController? controller;
  final bool isInitialized;
  final bool hasError;
  final String? thumbnailUrl;

  const _VideoPlayer({
    this.controller,
    required this.isInitialized,
    required this.hasError,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildFallback();
    }

    if (!isInitialized || controller == null) {
      return Stack(
        children: [
          if (thumbnailUrl != null)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                fit: BoxFit.cover,
              ),
            ),
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ],
      );
    }

    return Chewie(controller: controller!);
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.cardDark,
      child: Stack(
        children: [
          if (thumbnailUrl != null)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                fit: BoxFit.cover,
              ),
            ),
          Container(color: Colors.black45),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_outline_rounded,
                    color: Colors.white60, size: 56),
                SizedBox(height: 8),
                Text(
                  'Video unavailable',
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaInfoRow extends StatelessWidget {
  final ArticleEntity article;

  const _MetaInfoRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        // Author avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (article.author?.isNotEmpty == true
                      ? article.author![0]
                      : article.sourceName?[0] ?? 'N')
                  .toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.author ?? article.sourceName ?? 'Unknown Author',
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                AppUtils.formatDate(article.publishedAt),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_outlined,
                  size: 13, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                AppUtils.formatReadTime(article.content),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadMoreButton extends StatelessWidget {
  final String url;

  const _ReadMoreButton({required this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.open_in_new_rounded, size: 18),
        label: const Text('Read Full Article'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
