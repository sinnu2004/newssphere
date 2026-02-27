// lib/domain/repositories/news_repository.dart

import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getTopHeadlines({
    String? country,
    String? category,
    int page,
    int pageSize,
  });

  Future<List<ArticleEntity>> searchNews({
    required String query,
    int page,
    int pageSize,
  });

  Future<List<ArticleEntity>> getEverything({
    String? category,
    int page,
    int pageSize,
  });

  List<ArticleEntity> getBookmarks();
  Future<void> saveBookmark(ArticleEntity article);
  Future<void> removeBookmark(String articleId);
  bool isBookmarked(String articleId);

  List<ArticleEntity> getCachedArticles();
  Future<void> cacheArticles(List<ArticleEntity> articles);
}
