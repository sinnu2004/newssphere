// lib/domain/usecases/get_top_headlines.dart

import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesUseCase {
  final NewsRepository _repository;

  GetTopHeadlinesUseCase(this._repository);

  Future<List<ArticleEntity>> call({
    String? country = 'us',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getTopHeadlines(
      country: country,
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}

class SearchNewsUseCase {
  final NewsRepository _repository;

  SearchNewsUseCase(this._repository);

  Future<List<ArticleEntity>> call({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.searchNews(query: query, page: page, pageSize: pageSize);
  }
}

class GetEverythingUseCase {
  final NewsRepository _repository;

  GetEverythingUseCase(this._repository);

  Future<List<ArticleEntity>> call({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getEverything(category: category, page: page, pageSize: pageSize);
  }
}

class BookmarkUseCases {
  final NewsRepository _repository;

  BookmarkUseCases(this._repository);

  List<ArticleEntity> getBookmarks() => _repository.getBookmarks();

  Future<void> toggleBookmark(ArticleEntity article) async {
    if (_repository.isBookmarked(article.uniqueId)) {
      await _repository.removeBookmark(article.uniqueId);
    } else {
      await _repository.saveBookmark(article);
    }
  }

  bool isBookmarked(String articleId) => _repository.isBookmarked(articleId);
}
