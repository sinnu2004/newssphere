// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/article_entity.dart';
import '../providers/app_providers.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/shimmer_widgets.dart';
import '../widgets/error_widgets.dart';
import '../../core/utils/app_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  final _carouselController = PageController();
  int _currentCarouselPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final category = ref.read(selectedCategoryProvider);
      ref.read(headlineNewsProvider.notifier).loadMore(category: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(headlineNewsProvider);
    final isDark = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final category = ref.read(selectedCategoryProvider);
          await ref.read(headlineNewsProvider.notifier).refresh(category: category);
        },
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor:
                  isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              elevation: 0,
              title: Row(
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.language_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () =>
                      ref.read(themeProvider.notifier).toggleTheme(),
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                    ),
                    const SizedBox(height: 6),
                    CategoryChips(
                      onCategorySelected: (category) {
                        ref
                            .read(headlineNewsProvider.notifier)
                            .fetchNews(category: category);
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),

            // Content
            newsAsync.when(
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) return const _SectionHeader(title: 'Breaking News');
                    if (index == 1) return const ShimmerCarouselCard();
                    if (index == 2) return const SizedBox(height: 16);
                    if (index == 3) return const _SectionHeader(title: 'Latest News');
                    return const ShimmerNewsCard();
                  },
                  childCount: 10,
                ),
              ),
              error: (err, _) => SliverFillRemaining(
                child: ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () {
                    ref.read(headlineNewsProvider.notifier).fetchNews();
                  },
                ),
              ),
              data: (articles) {
                if (articles.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyStateWidget(
                      title: 'No News Found',
                      subtitle: 'Try a different category or check back later.',
                      icon: Icons.newspaper_outlined,
                    ),
                  );
                }

                final featuredArticles = articles.take(5).toList();
                final latestArticles = articles.skip(5).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Breaking news header
                      if (index == 0) {
                        return _SectionHeader(
                          title: 'Breaking News',
                          badge: 'LIVE',
                        );
                      }

                      // Carousel
                      if (index == 1) {
                        return _BreakingNewsCarousel(
                          articles: featuredArticles,
                          controller: _carouselController,
                          currentPage: _currentCarouselPage,
                          onPageChanged: (page) {
                            setState(() => _currentCarouselPage = page);
                          },
                        );
                      }

                      // Page indicator
                      if (index == 2) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: _carouselController,
                              count: featuredArticles.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: theme.colorScheme.primary,
                                dotColor: theme.colorScheme.primary.withOpacity(0.3),
                                dotHeight: 6,
                                dotWidth: 6,
                                expansionFactor: 3,
                                spacing: 4,
                              ),
                            ),
                          ),
                        );
                      }

                      // Latest news header
                      if (index == 3) {
                        return const _SectionHeader(title: 'Latest News');
                      }

                      // News items
                      final articleIndex = index - 4;
                      if (articleIndex < latestArticles.length) {
                        final article = latestArticles[articleIndex];
                        // Alternate between card and compact
                        if (articleIndex % 3 == 0) {
                          return NewsCard(article: article);
                        } else {
                          return Column(
                            children: [
                              CompactNewsCard(article: article),
                              if (articleIndex < latestArticles.length - 1)
                                Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight,
                                ),
                            ],
                          );
                        }
                      }

                      // Loading indicator at bottom
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    childCount: 4 + latestArticles.length + 1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakingNewsCarousel extends StatelessWidget {
  final List<ArticleEntity> articles;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _BreakingNewsCarousel({
    required this.articles,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final height = ResponsiveHelper.carouselHeight(context);

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onPageChanged,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return FeaturedNewsCard(article: articles[index]);
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.badge,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.breakingColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


