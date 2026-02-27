// lib/data/repositories/news_repository_impl.dart

import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../datasources/news_local_datasource.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remote;
  final NewsLocalDataSource _local;

  NewsRepositoryImpl({
    required NewsRemoteDataSource remote,
    required NewsLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  // Mapper: Model -> Entity
  ArticleEntity _toEntity(ArticleModel model) {
    return ArticleEntity(
      id: model.uniqueId,
      sourceName: model.source?.name,
      sourceId: model.source?.id,
      author: model.author,
      title: model.title,
      description: model.description,
      url: model.url,
      imageUrl: model.urlToImage,
      videoUrl: model.videoUrl,
      publishedAt: model.publishedAt,
      content: model.content,
      category: model.category,
    );
  }

  // Mapper: Entity -> Model
  ArticleModel _toModel(ArticleEntity entity) {
    return ArticleModel(
      source: entity.sourceName != null
          ? SourceModel(id: entity.sourceId, name: entity.sourceName)
          : null,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.imageUrl,
      publishedAt: entity.publishedAt,
      content: entity.content,
      videoUrl: entity.videoUrl,
      category: entity.category,
    );
  }

  @override
  Future<List<ArticleEntity>> getTopHeadlines({
    String? country = 'us',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _remote.getTopHeadlines(
        country: country,
        category: category,
        page: page,
        pageSize: pageSize,
      );
      final articles = response.articles ?? [];
      final entities = articles.map(_toEntity).toList();

      // Cache first page
      if (page == 1) {
        await _local.cacheArticles(articles);
      }

      return entities;
    } catch (_) {
      // On error, return cached if first page
      if (page == 1) {
        final cached = _local.getCachedArticles();
        if (cached.isNotEmpty) return cached.map(_toEntity).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<ArticleEntity>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _remote.searchNews(
      query: query,
      page: page,
      pageSize: pageSize,
    );
    return (response.articles ?? []).map(_toEntity).toList();
  }

  @override
  Future<List<ArticleEntity>> getEverything({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _remote.getEverything(
      category: category,
      page: page,
      pageSize: pageSize,
    );
    return (response.articles ?? []).map(_toEntity).toList();
  }

  @override
  List<ArticleEntity> getBookmarks() {
    return _local.getBookmarks().map(_toEntity).toList();
  }

  @override
  Future<void> saveBookmark(ArticleEntity article) async {
    await _local.saveBookmark(_toModel(article));
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    await _local.removeBookmark(articleId);
  }

  @override
  bool isBookmarked(String articleId) => _local.isBookmarked(articleId);

  @override
  List<ArticleEntity> getCachedArticles() {
    return _local.getCachedArticles().map(_toEntity).toList();
  }

  @override
  Future<void> cacheArticles(List<ArticleEntity> articles) async {
    await _local.cacheArticles(articles.map(_toModel).toList());
  }
}
