// lib/core/utils/app_utils.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppUtils {
  AppUtils._();

  static String formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';
    return timeago.format(date);
  }

  static String formatReadTime(String? content) {
    if (content == null || content.isEmpty) return '2 min read';
    final wordCount = content.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return '$minutes min read';
  }

  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static bool isVideoUrl(String? url) {
    if (url == null) return false;
    final lower = url.toLowerCase();
    return lower.contains('.mp4') ||
        lower.contains('.m3u8') ||
        lower.contains('youtube') ||
        lower.contains('vimeo') ||
        lower.contains('.webm') ||
        lower.contains('.mov');
  }

  static String getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'technology':
        return '#6C63FF';
      case 'sports':
        return '#00C896';
      case 'business':
        return '#FF6B35';
      case 'health':
        return '#E91E8C';
      case 'science':
        return '#00BCD4';
      case 'entertainment':
        return '#FFB300';
      default:
        return '#78909C';
    }
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 600) return 2;
    return 1;
  }

  static double carouselHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 600) return 300;
    return 220;
  }
}
