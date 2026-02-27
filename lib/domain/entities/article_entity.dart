// lib/domain/entities/article_entity.dart

class ArticleEntity {
  final String? id;
  final String? sourceName;
  final String? sourceId;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime? publishedAt;
  final String? content;
  final String? category;

  const ArticleEntity({
    this.id,
    this.sourceName,
    this.sourceId,
    this.author,
    this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.videoUrl,
    this.publishedAt,
    this.content,
    this.category,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  String get uniqueId => url ?? title ?? DateTime.now().toIso8601String();

  ArticleEntity copyWith({
    String? id,
    String? sourceName,
    String? sourceId,
    String? author,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? videoUrl,
    DateTime? publishedAt,
    String? content,
    String? category,
  }) {
    return ArticleEntity(
      id: id ?? this.id,
      sourceName: sourceName ?? this.sourceName,
      sourceId: sourceId ?? this.sourceId,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleEntity &&
          runtimeType == other.runtimeType &&
          uniqueId == other.uniqueId;

  @override
  int get hashCode => uniqueId.hashCode;
}
