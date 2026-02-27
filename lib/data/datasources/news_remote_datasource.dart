// lib/data/datasources/news_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/article_model.dart';
import '../../core/constants/app_constants.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines({
    String? country,
    String? category,
    int page,
    int pageSize,
  });

  Future<NewsResponseModel> searchNews({
    required String query,
    int page,
    int pageSize,
  });

  Future<NewsResponseModel> getEverything({
    String? category,
    String? language,
    int page,
    int pageSize,
    String? sortBy,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<NewsResponseModel> getTopHeadlines({
    String? country = 'us',
    String? category,
    int page = 1,
    int pageSize = AppConstants.pageSize,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'apiKey': AppConstants.apiKey, // REPLACE WITH YOUR API KEY
        'page': page,
        'pageSize': pageSize,
      };

      if (country != null && (category == null || category == 'all')) {
        params['country'] = country;
      }

      if (category != null && category != 'all') {
        params['category'] = category;
        params['country'] = country ?? 'us';
      }

      final response = await _dio.get(
        AppConstants.topHeadlines,
        queryParameters: params,
      );

      return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<NewsResponseModel> searchNews({
    required String query,
    int page = 1,
    int pageSize = AppConstants.pageSize,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.everything,
        queryParameters: {
          'apiKey': AppConstants.apiKey, // REPLACE WITH YOUR API KEY
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'sortBy': 'relevancy',
          'language': 'en',
        },
      );

      return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<NewsResponseModel> getEverything({
    String? category,
    String? language = 'en',
    int page = 1,
    int pageSize = AppConstants.pageSize,
    String? sortBy = 'publishedAt',
  }) async {
    try {
      final Map<String, dynamic> params = {
        'apiKey': AppConstants.apiKey, // REPLACE WITH YOUR API KEY
        'page': page,
        'pageSize': pageSize,
        'sortBy': sortBy ?? 'publishedAt',
        'language': language ?? 'en',
      };

      if (category != null && category != 'all') {
        params['q'] = category;
      } else {
        params['q'] = 'news'; // Default query
      }

      final response = await _dio.get(
        AppConstants.everything,
        queryParameters: params,
      );

      return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return Exception('Invalid API key.');
        if (statusCode == 429) return Exception('Too many requests. Try again later.');
        return Exception('Server error: $statusCode');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}

// Dio factory
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add logging interceptor in debug
  dio.interceptors.add(
    LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
    ),
  );

  return dio;
}
