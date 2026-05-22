// lib/core/utils/report_status_helper.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class ReportStatusHelper {
  ReportStatusHelper._();

  static Color getStatusColor(String status, AppColors colors) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'new':
        return colors.info; // Blue for new/pending
      case 'acknowledged':
      case 'in_progress':
      case 'in-progress':
        return colors.warning; // Orange for in progress
      case 'resolved':
        return colors.success; // Green for resolved
      case 'rejected':
        return colors.error; // Red for rejected
      case 'closed':
        return colors.textSecondary; // Gray for closed
      default:
        return colors.textSecondary;
    }
  }

  static String getStatusText(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'new':
        return l10n.statusPending;
      case 'acknowledged':
      case 'in_progress':
      case 'in-progress':
        return l10n.statusInProgress;
      case 'resolved':
        return l10n.statusResolved;
      case 'rejected':
        return l10n.statusRejected;
      case 'closed':
        return l10n.statusClosed;
      default:
        return status;
    }
  }
}
