// lib/data/models/article_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class ArticleModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'source')
  final SourceModel? source;

  @HiveField(1)
  @JsonKey(name: 'author')
  final String? author;

  @HiveField(2)
  @JsonKey(name: 'title')
  final String? title;

  @HiveField(3)
  @JsonKey(name: 'description')
  final String? description;

  @HiveField(4)
  @JsonKey(name: 'url')
  final String? url;

  @HiveField(5)
  @JsonKey(name: 'urlToImage')
  final String? urlToImage;

  @HiveField(6)
  @JsonKey(name: 'publishedAt')
  final DateTime? publishedAt;

  @HiveField(7)
  @JsonKey(name: 'content')
  final String? content;

  // Extra field for video support (extend from your API)
  @HiveField(8)
  @JsonKey(name: 'videoUrl')
  final String? videoUrl;

  @HiveField(9)
  @JsonKey(name: 'category')
  final String? category;

  ArticleModel({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.videoUrl,
    this.category,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  String get uniqueId => url ?? title ?? DateTime.now().toIso8601String();

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => urlToImage != null && urlToImage!.isNotEmpty;

  @override
  String toString() => 'ArticleModel(title: $title, url: $url)';
}

@HiveType(typeId: 1)
@JsonSerializable()
class SourceModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String? id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;

  SourceModel({this.id, this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceModelToJson(this);
}

@JsonSerializable()
class NewsResponseModel {
  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'totalResults')
  final int? totalResults;

  @JsonKey(name: 'articles')
  final List<ArticleModel>? articles;

  NewsResponseModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseModelToJson(this);
}
