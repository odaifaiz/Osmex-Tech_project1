// lib/core/utils/formatters.dart

import 'package:intl/intl.dart';

/// A class containing static methods for formatting data.
class Formatters {
  // This class is not meant to be instantiated.
  Formatters._();

  /// Formats a DateTime object into a user-friendly string like "Mar 25, 2026".
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Formats a DateTime object into a string with date and time like "Mar 25, 2026, 08:30 PM".
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy, hh:mm a').format(date);
  }

  /// Formats a number with commas as thousands separators (e.g., 10000 -> "10,000").
  static String formatNumber(num number) {
    return NumberFormat.decimalPattern().format(number);
  }

  /// Returns a "time ago" string (e.g., "5m ago", "1h ago", "2d ago").
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }
}
