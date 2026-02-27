// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // API Configuration - REPLACE WITH YOUR API KEYS
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'pub_7d0338b405314526bbfb4ddf6ca67813'; // Replace with your key
  static const String apiKeyParam = 'apiKey';

  // API Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  static const String sources = '/sources';

  // App Info
  static const String appName = 'NewsSphere';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Cache
  static const String bookmarksBoxName = 'bookmarks';
  static const String settingsBoxName = 'settings';
  static const String cachedArticlesBoxName = 'cached_articles';

  // SharedPrefs Keys
  static const String themeKey = 'is_dark_theme';
  static const String selectedCategoryKey = 'selected_category';
  static const String onboardingKey = 'onboarding_done';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Image placeholder
  static const String placeholderImage =
      'https://via.placeholder.com/400x200?text=No+Image';
}

class NewsCategories {
  NewsCategories._();

  static const List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'All', 'icon': '🌐'},
    {'id': 'business', 'name': 'Business', 'icon': '💼'},
    {'id': 'entertainment', 'name': 'Entertainment', 'icon': '🎬'},
    {'id': 'general', 'name': 'General', 'icon': '📰'},
    {'id': 'health', 'name': 'Health', 'icon': '❤️'},
    {'id': 'science', 'name': 'Science', 'icon': '🔬'},
    {'id': 'sports', 'name': 'Sports', 'icon': '⚽'},
    {'id': 'technology', 'name': 'Technology', 'icon': '💻'},
  ];
}

class AppSizes {
  AppSizes._();

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const double cardElevation = 2.0;
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 70.0;
  static const double carouselHeight = 220.0;
  static const double categoryChipHeight = 38.0;
  static const double newsCardImageHeight = 200.0;
  static const double thumbnailWidth = 100.0;
  static const double thumbnailHeight = 80.0;
}
