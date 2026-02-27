// lib/presentation/screens/bookmarks_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/news_card.dart';
import '../widgets/error_widgets.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Saved Articles', style: theme.textTheme.headlineMedium),
            actions: [
              if (bookmarks.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    _showClearDialog(context, ref);
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[400],
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          if (bookmarks.isEmpty)
            const SliverFillRemaining(
              child: EmptyStateWidget(
                title: 'No Saved Articles',
                subtitle:
                    'Bookmark articles to read them later, even offline.',
                icon: Icons.bookmark_border_rounded,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        '${bookmarks.length} saved article${bookmarks.length == 1 ? '' : 's'}',
                        style: theme.textTheme.labelMedium,
                      ),
                    );
                  }

                  final article = bookmarks[index - 1];
                  return Dismissible(
                    key: Key(article.uniqueId),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(bookmarksProvider.notifier).toggleBookmark(article);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Article removed from bookmarks'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              ref.read(bookmarksProvider.notifier).toggleBookmark(article);
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red[700],
                      child: const Icon(Icons.delete_rounded, color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        CompactNewsCard(article: article),
                        if (index < bookmarks.length)
                          Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.dividerLight,
                          ),
                      ],
                    ),
                  );
                },
                childCount: bookmarks.length + 1,
              ),
            ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks?'),
        content: const Text(
            'This will remove all your saved articles. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final bookmarks = ref.read(bookmarksProvider);
              for (final article in bookmarks) {
                ref.read(bookmarksProvider.notifier).toggleBookmark(article);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text('Clear All'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
