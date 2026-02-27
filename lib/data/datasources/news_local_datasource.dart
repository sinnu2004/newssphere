// lib/data/datasources/news_local_datasource.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/article_model.dart';
import '../../core/constants/app_constants.dart';

abstract class NewsLocalDataSource {
  List<ArticleModel> getBookmarks();
  Future<void> saveBookmark(ArticleModel article);
  Future<void> removeBookmark(String articleId);
  bool isBookmarked(String articleId);
  List<ArticleModel> getCachedArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box<ArticleModel> _bookmarksBox;
  final Box<ArticleModel> _cachedArticlesBox;

  NewsLocalDataSourceImpl({
    required Box<ArticleModel> bookmarksBox,
    required Box<ArticleModel> cachedArticlesBox,
  })  : _bookmarksBox = bookmarksBox,
        _cachedArticlesBox = cachedArticlesBox;

  @override
  List<ArticleModel> getBookmarks() {
    return _bookmarksBox.values.toList().reversed.toList();
  }

  @override
  Future<void> saveBookmark(ArticleModel article) async {
    await _bookmarksBox.put(article.uniqueId, article);
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    await _bookmarksBox.delete(articleId);
  }

  @override
  bool isBookmarked(String articleId) {
    return _bookmarksBox.containsKey(articleId);
  }

  @override
  List<ArticleModel> getCachedArticles() {
    return _cachedArticlesBox.values.toList();
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    await _cachedArticlesBox.clear();
    final Map<String, ArticleModel> articlesMap = {
      for (final article in articles) article.uniqueId: article
    };
    await _cachedArticlesBox.putAll(articlesMap);
  }

  @override
  Future<void> clearCache() async {
    await _cachedArticlesBox.clear();
  }
}

// Hive setup helper
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleModelAdapter());
  Hive.registerAdapter(SourceModelAdapter());
  await Hive.openBox<ArticleModel>(AppConstants.bookmarksBoxName);
  await Hive.openBox<ArticleModel>(AppConstants.cachedArticlesBoxName);
}
