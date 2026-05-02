// lib/presentation/screens/reports/my_reports_screen.dart

import 'package:city_fix_app/domain/entities/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';
import 'package:city_fix_app/presentation/widgets/common/app_image_widget.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class MyReportsScreen extends ConsumerStatefulWidget {
  const MyReportsScreen({super.key});

  @override
  ConsumerState<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends ConsumerState<MyReportsScreen> {
  final int _currentTabIndex = 1;
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final reportsAsync = ref.watch(userReportsProvider(_selectedFilter));
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(l10n, colors),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteConstants.createReportRouteName),
        backgroundColor: colors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          statsAsync.when(
            data: (stats) => _buildStatsOverview(stats, l10n, colors),
            loading: () => _buildStatsLoading(l10n, colors),
            error: (_, __) => _buildStatsOverview({'total': 0, 'resolved': 0, 'inProgress': 0}, l10n, colors),
          ),
          _buildFilterTabs(l10n, colors),
          Expanded(
            child: reportsAsync.when(
              data: (reports) => _buildReportsList(reports, l10n, colors),
              loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
              error: (error, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: colors.error),
                    const SizedBox(height: 16),
                    Text(l10n.errorLoadingReports, style: AppTypography.body1.copyWith(color: colors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(error.toString(), style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(userReportsProvider(_selectedFilter));
                        ref.invalidate(userStatsProvider);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                      child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == _currentTabIndex) return;
          switch (index) {
            case 0:
              context.goNamed(RouteConstants.homeRouteName);
              break;
            case 2:
              context.goNamed(RouteConstants.mapRouteName);
              break;
            case 3:
              context.goNamed(RouteConstants.settingsRouteName);
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatsOverview(Map<String, int> stats, AppLocalizations l10n, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Expanded(
            child: StatsSummaryCard(
              title: l10n.total,
              value: '${stats['total'] ?? 0}',
              color: colors.info,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatsSummaryCard(
              title: l10n.resolved,
              value: '${stats['resolved'] ?? 0}',
              color: colors.success,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatsSummaryCard(
              title: l10n.statusInProgress,
              value: '${stats['inProgress'] ?? 0}',
              color: colors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsLoading(AppLocalizations l10n, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Expanded(child: StatsSummaryCard(title: l10n.total, value: '...', color: colors.info)),
          const SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: l10n.resolved, value: '...', color: colors.success)),
          const SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: l10n.statusInProgress, value: '...', color: colors.warning)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppLocalizations l10n, AppColors colors) {
    final List<Map<String, String?>> filters = [
      {'label': l10n.all, 'key': null},
      {'label': l10n.statusPending, 'key': 'new'},
      {'label': l10n.statusInProgress, 'key': 'in_progress'},
      {'label': l10n.statusResolved, 'key': 'resolved'},
      {'label': l10n.statusClosed, 'key': 'closed'},
    ];

    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = _selectedFilter == filter['key'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter['key'];
              });
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isActive ? colors.primary : colors.card,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isActive ? Colors.transparent : colors.border.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    color: isActive ? Colors.white : colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportsList(List<Report> reports, AppLocalizations l10n, AppColors colors) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: colors.textSecondary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(l10n.noReports, style: AppTypography.body1.copyWith(color: colors.textSecondary)),
            const SizedBox(height: 8),
            Text(l10n.createFirstReport, style: AppTypography.caption.copyWith(color: colors.textSecondary.withOpacity(0.5))),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(l10n.latestReports, style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary)),
        ),
        ...reports.map((report) => _buildReportCard(report, l10n, colors)),
      ],
    );
  }

  Widget _buildReportCard(Report report, AppLocalizations l10n, AppColors colors) {
    final statusText = _getStatusText(context, report.status);
    final statusColor = _getStatusColor(report.status, colors);
    final imageUrl = report.imageUrls?.isNotEmpty == true ? report.imageUrls!.first : '';
    final timeAgo = _formatDate(context, report.createdAt);

    return InkWell(
      onTap: () => context.pushNamed(RouteConstants.reportDetailsRouteName, extra: report.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImageWidget(
                  imageUrl: imageUrl,
                  height: 160,
                  width: double.infinity,
                  borderRadius: 20,
                  fit: BoxFit.cover,
                ),
                PositionedDirectional(
                  top: 12,
                  end: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          report.title,
                          style: AppTypography.headline3.copyWith(fontSize: 16, color: colors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(timeAgo, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(report.address, style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(
                    report.description,
                    style: AppTypography.body2.copyWith(color: colors.textSecondary, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'new': return l10n.statusPending;
      case 'pending': return l10n.statusPending;
      case 'acknowledged': return l10n.statusInProgress;
      case 'in_progress': return l10n.statusInProgress;
      case 'resolved': return l10n.statusResolved;
      case 'rejected': return l10n.statusRejected;
      case 'closed': return l10n.statusClosed;
      default: return status;
    }
  }

  Color _getStatusColor(String status, AppColors colors) {
    switch (status) {
      case 'new': return colors.error;
      case 'pending': return colors.error;
      case 'acknowledged': return colors.warning;
      case 'in_progress': return colors.warning;
      case 'resolved': return colors.success;
      case 'rejected': return colors.error;
      case 'closed': return colors.textSecondary;
      default: return colors.textSecondary;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n, AppColors colors) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: AppDimensions.spacingM),
          Icon(Icons.location_city, color: colors.primary, size: 28),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            l10n.myReports,
            style: AppTypography.headline3.copyWith(
              fontSize: 18,
              color: colors.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.drafts_outlined, color: colors.textPrimary),
          onPressed: () => context.pushNamed(RouteConstants.draftsRouteName),
          tooltip: l10n.drafts,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
          child: IconButton(
            icon: Icon(Icons.search, color: colors.textPrimary),
            onPressed: () => context.pushNamed(RouteConstants.searchReportsRouteName),
          ),
        ),
      ],
    );
  }
}
