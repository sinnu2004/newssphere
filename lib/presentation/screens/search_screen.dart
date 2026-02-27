// lib/presentation/screens/search_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_widgets.dart';
import '../widgets/error_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _currentQuery = '';

  // Trending topics
  static const _trendingTopics = [
    '🤖 Artificial Intelligence',
    '💰 Stock Market',
    '🌍 Climate Change',
    '🏈 Super Bowl',
    '🚀 Space Exploration',
    '🎬 Hollywood',
    '⚽ Champions League',
    '💻 Tech Giants',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() => _currentQuery = value.trim());
    });
  }

  void _searchTopic(String topic) {
    // Strip emoji prefix
    final query = topic.replaceAll(RegExp(r'^[^\w]+'), '').trim();
    _searchController.text = query;
    setState(() => _currentQuery = query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Discover',
                    style: theme.textTheme.headlineLarge,
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search news, topics...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _currentQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _currentQuery.isEmpty
                  ? _TrendingTopicsView(
                      topics: _trendingTopics,
                      onTap: _searchTopic,
                    )
                  : _SearchResultsView(query: _currentQuery),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingTopicsView extends StatelessWidget {
  final List<String> topics;
  final ValueChanged<String> onTap;

  const _TrendingTopicsView({
    required this.topics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Topics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topics.map((topic) {
              return GestureDetector(
                onTap: () => onTap(topic),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                    ),
                  ),
                  child: Text(
                    topic,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Categories',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _CategoryTile(
                  name: 'Technology', emoji: '💻', color: AppColors.techColor),
              _CategoryTile(
                  name: 'Sports', emoji: '⚽', color: AppColors.sportsColor),
              _CategoryTile(
                  name: 'Business', emoji: '💼', color: AppColors.businessColor),
              _CategoryTile(
                  name: 'Health', emoji: '❤️', color: AppColors.healthColor),
              _CategoryTile(
                  name: 'Science', emoji: '🔬', color: AppColors.scienceColor),
              _CategoryTile(
                  name: 'Entertainment',
                  emoji: '🎬',
                  color: AppColors.entColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final String emoji;
  final Color color;

  const _CategoryTile({
    required this.name,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to filtered news
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  final String query;

  const _SearchResultsView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(query));

    return resultsAsync.when(
      loading: () => ListView.builder(
        itemCount: 8,
        itemBuilder: (_, __) => const ShimmerListItem(),
      ),
      error: (err, _) => ErrorStateWidget(
        message: 'Search failed: ${err.toString()}',
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return EmptyStateWidget(
            title: 'No results for "$query"',
            subtitle: 'Try different keywords or check your spelling.',
            icon: Icons.search_off_rounded,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${articles.length} results for "$query"',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: articles.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                itemBuilder: (context, index) {
                  return CompactNewsCard(article: articles[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
