// lib/core/utils/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/article_entity.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/article_detail_screen.dart';
import '../../presentation/screens/bookmarks_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/main_shell_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShellScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: '/bookmarks',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BookmarksScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/article',
      builder: (context, state) {
        final article = state.extra as ArticleEntity;
        return ArticleDetailScreen(article: article);
      },
    ),
  ],
);
