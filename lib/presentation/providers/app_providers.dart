// lib/presentation/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/news_local_datasource.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/models/article_model.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/news_usecases.dart';

// ─── Infrastructure Providers ───────────────────────────────────────────────

final dioProvider = Provider((ref) => createDio());

final bookmarksBoxProvider = Provider<Box<ArticleModel>>(
  (ref) => Hive.box<ArticleModel>(AppConstants.bookmarksBoxName),
);

final cachedArticlesBoxProvider = Provider<Box<ArticleModel>>(
  (ref) => Hive.box<ArticleModel>(AppConstants.cachedArticlesBoxName),
);

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart using override');
});

// ─── Data Layer Providers ────────────────────────────────────────────────────

final remoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final localDataSourceProvider = Provider<NewsLocalDataSource>((ref) {
  return NewsLocalDataSourceImpl(
    bookmarksBox: ref.watch(bookmarksBoxProvider),
    cachedArticlesBox: ref.watch(cachedArticlesBoxProvider),
  );
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    remote: ref.watch(remoteDataSourceProvider),
    local: ref.watch(localDataSourceProvider),
  );
});

// ─── Use Case Providers ──────────────────────────────────────────────────────

final getTopHeadlinesUseCaseProvider = Provider<GetTopHeadlinesUseCase>((ref) {
  return GetTopHeadlinesUseCase(ref.watch(newsRepositoryProvider));
});

final searchNewsUseCaseProvider = Provider<SearchNewsUseCase>((ref) {
  return SearchNewsUseCase(ref.watch(newsRepositoryProvider));
});

final getEverythingUseCaseProvider = Provider<GetEverythingUseCase>((ref) {
  return GetEverythingUseCase(ref.watch(newsRepositoryProvider));
});

final bookmarkUseCasesProvider = Provider<BookmarkUseCases>((ref) {
  return BookmarkUseCases(ref.watch(newsRepositoryProvider));
});

// ─── Theme Provider ──────────────────────────────────────────────────────────

class ThemeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs) : super(_prefs.getBool(AppConstants.themeKey) ?? false);

  void toggleTheme() {
    state = !state;
    _prefs.setBool(AppConstants.themeKey, state);
  }

  bool get isDark => state;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ThemeNotifier(prefs);
});

// ─── Category Provider ───────────────────────────────────────────────────────

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

// ─── Search Query Provider ───────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Headline News Provider ──────────────────────────────────────────────────

class HeadlineNewsNotifier extends StateNotifier<AsyncValue<List<ArticleEntity>>> {
  final GetTopHeadlinesUseCase _useCase;
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  List<ArticleEntity> _articles = [];

  HeadlineNewsNotifier(this._useCase) : super(const AsyncLoading()) {
    fetchNews();
  }

  Future<void> fetchNews({String? category}) async {
    _page = 1;
    _hasMore = true;
    _articles = [];
    state = const AsyncLoading();

    try {
      final articles = await _useCase(
        category: (category == null || category == 'all') ? null : category,
        page: _page,
      );
      _articles = articles;
      state = AsyncData(articles);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore({String? category}) async {
    if (!_hasMore || _isFetchingMore) return;
    _isFetchingMore = true;
    _page++;

    try {
      final newArticles = await _useCase(
        category: (category == null || category == 'all') ? null : category,
        page: _page,
      );

      if (newArticles.isEmpty) {
        _hasMore = false;
      } else {
        _articles = [..._articles, ...newArticles];
        state = AsyncData(List.from(_articles));
      }
    } catch (_) {
      _page--;
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> refresh({String? category}) => fetchNews(category: category);
}

final headlineNewsProvider =
    StateNotifierProvider<HeadlineNewsNotifier, AsyncValue<List<ArticleEntity>>>(
  (ref) => HeadlineNewsNotifier(ref.watch(getTopHeadlinesUseCaseProvider)),
);

// ─── Search Results Provider ─────────────────────────────────────────────────

final searchResultsProvider =
    FutureProvider.family<List<ArticleEntity>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final useCase = ref.watch(searchNewsUseCaseProvider);
  return useCase(query: query);
});

// ─── Bookmarks Provider ──────────────────────────────────────────────────────

class BookmarksNotifier extends StateNotifier<List<ArticleEntity>> {
  final BookmarkUseCases _useCases;

  BookmarksNotifier(this._useCases) : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    state = _useCases.getBookmarks();
  }

  Future<void> toggleBookmark(ArticleEntity article) async {
    await _useCases.toggleBookmark(article);
    _loadBookmarks();
  }

  bool isBookmarked(String articleId) => _useCases.isBookmarked(articleId);
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<ArticleEntity>>(
  (ref) => BookmarksNotifier(ref.watch(bookmarkUseCasesProvider)),
);

// ─── Bottom Nav Provider ─────────────────────────────────────────────────────

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
