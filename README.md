# NewsSphere - Flutter News App 📰

A modern, feature-rich Flutter news application built with Clean Architecture + MVVM.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code

### Installation

```bash
# Clone or extract the project
cd newssphere

# Install dependencies
flutter pub get

# Generate code (models, adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

## 🔑 API Configuration

> **IMPORTANT:** Replace the API key before running.

1. Open `lib/core/constants/app_constants.dart`
2. Replace `YOUR_NEWS_API_KEY_HERE` with your actual key:
   ```dart
   static const String apiKey = 'YOUR_ACTUAL_KEY';
   ```
3. Get a free API key at: https://newsapi.org

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants, categories, sizes
│   ├── theme/          # Light/Dark theme, colors, typography
│   └── utils/          # Router, utilities, responsive helpers
│
├── data/
│   ├── models/         # Article, Source, NewsResponse models (Hive + JSON)
│   ├── repositories/   # Repository implementation + entity mapper
│   └── datasources/    # Remote (Dio/API) + Local (Hive) data sources
│
├── domain/
│   ├── entities/       # ArticleEntity (pure Dart, no dependencies)
│   ├── usecases/       # GetTopHeadlines, SearchNews, BookmarkUseCases
│   └── repositories/   # NewsRepository interface
│
├── presentation/
│   ├── screens/        # HomeScreen, ArticleDetailScreen, SearchScreen,
│   │                   # BookmarksScreen, SettingsScreen, MainShellScreen
│   ├── widgets/        # NewsCard, CompactCard, FeaturedCard, CategoryChips,
│   │                   # ShimmerWidgets, ErrorWidgets
│   └── providers/      # Riverpod providers for all state management
│
└── main.dart           # App entry point
```

---

## ✨ Features

| Feature | Status |
|---------|--------|
| Breaking news carousel | ✅ |
| Category filtering | ✅ |
| Infinite scroll pagination | ✅ |
| Pull-to-refresh | ✅ |
| Search with debounce | ✅ |
| Bookmark articles | ✅ |
| Dark/Light theme | ✅ |
| Shimmer loading | ✅ |
| Offline cached articles | ✅ |
| Video player support | ✅ |
| Swipe to dismiss bookmarks | ✅ |
| Share articles | ✅ |
| Read time estimate | ✅ |
| Responsive (phone + tablet) | ✅ |
| Error handling with retry | ✅ |

---

## 🎨 Design

- **Typography:** Playfair Display (headlines) + Space Grotesk (UI) + Source Serif 4 (body)
- **Colors:** Deep navy dark theme, clean white light theme, vivid category accent colors
- **Architecture:** Clean Architecture + MVVM with Riverpod

---

## 🔧 Replacing the API

The app is built for **NewsAPI.org** by default. To use a different API:

1. Update `AppConstants.baseUrl` in `app_constants.dart`
2. Update query parameters in `news_remote_datasource.dart`
3. Update `NewsResponseModel` in `article_model.dart` to match your JSON structure
4. Update `_$ArticleModelFromJson` in `article_model.g.dart`

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `dio` | HTTP client |
| `hive_flutter` | Local storage / bookmarks |
| `cached_network_image` | Image caching |
| `shimmer` | Loading skeleton UI |
| `video_player` + `chewie` | Video playback |
| `google_fonts` | Typography |
| `smooth_page_indicator` | Carousel dots |
| `share_plus` | Share articles |
| `url_launcher` | Open article URLs |

---

## 📱 Screenshots

The app includes:
- **Home Screen**: Carousel, category chips, mixed card/list layout
- **Detail Screen**: Hero image/video, full article content
- **Search Screen**: Trending topics, category grid, live results
- **Bookmarks Screen**: Swipe-to-delete, offline reading
- **Settings Screen**: Theme, notifications, cache management
