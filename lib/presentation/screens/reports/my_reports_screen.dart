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
  String? _selectedFilter; // NULL means "ALL"

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportsAsync = ref.watch(userReportsProvider(_selectedFilter));
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteConstants.createReportRouteName),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          // User Stats
          statsAsync.when(
            data: (stats) => _buildStatsOverview(stats, l10n),
            loading: () => _buildStatsLoading(l10n),
            error: (_, __) => _buildStatsOverview({'total': 0, 'resolved': 0, 'inProgress': 0}, l10n),
          ),
          
          // Filter Tabs
          _buildFilterTabs(l10n),
          
          // Reports List
          Expanded(
            child: reportsAsync.when(
              data: (reports) => _buildReportsList(reports, l10n),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (error, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: AppColors.statusError),
                    const SizedBox(height: 16),
                    Text(l10n.errorLoadingReports, style: AppTypography.body1),
                    const SizedBox(height: 8),
                    Text(error.toString(), style: AppTypography.caption.copyWith(color: AppColors.textHint)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(userReportsProvider(_selectedFilter));
                        ref.invalidate(userStatsProvider);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(l10n.retry, style: const TextStyle(color: Colors.black)),
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

  Widget _buildStatsOverview(Map<String, int> stats, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Expanded(
            child: StatsSummaryCard(
              title: l10n.total,
              value: '${stats['total'] ?? 0}',
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatsSummaryCard(
              title: l10n.resolved,
              value: '${stats['resolved'] ?? 0}',
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatsSummaryCard(
              title: l10n.statusInProgress,
              value: '${stats['inProgress'] ?? 0}',
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsLoading(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Expanded(child: StatsSummaryCard(title: l10n.total, value: '...', color: Colors.cyanAccent)),
          const SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: l10n.resolved, value: '...', color: Colors.greenAccent)),
          const SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: l10n.statusInProgress, value: '...', color: Colors.orangeAccent)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppLocalizations l10n) {
    // Map Localized Labels to Backend Status Keys
    final List<Map<String, String?>> filters = [
      {'label': l10n.all, 'key': null},
      {'label': l10n.statusPending, 'key': 'pending'},
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
              // Automatic refresh via riverpod watch
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.cardDark,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
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

  Widget _buildReportsList(List<Report> reports, AppLocalizations l10n) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 80, color: AppColors.cardDark),
            const SizedBox(height: 16),
            Text(l10n.noReports, style: AppTypography.body1.copyWith(color: AppColors.textSecondaryLight)),
            const SizedBox(height: 8),
            Text(l10n.createFirstReport, style: AppTypography.caption.copyWith(color: AppColors.textHint)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(l10n.latestReports, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        ...reports.map((report) => _buildReportCard(report, l10n)),
      ],
    );
  }

  Widget _buildReportCard(Report report, AppLocalizations l10n) {
    final statusText = _getStatusText(context, report.status);
    final statusColor = _getStatusColor(report.status);
    final imageUrl = report.imageUrls?.isNotEmpty == true ? report.imageUrls!.first : '';
    final timeAgo = _formatDate(context, report.createdAt);

    return InkWell(
      onTap: () => context.pushNamed(RouteConstants.reportDetailsRouteName, extra: report.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
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
                  borderRadius: 20, // Should use a custom clipper or borderRadius for top only if needed
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
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(report.address, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(
                    report.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
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
      case 'pending': return l10n.statusPending;
      case 'acknowledged': return l10n.statusInProgress;
      case 'in_progress': return l10n.statusInProgress;
      case 'resolved': return l10n.statusResolved;
      case 'rejected': return l10n.statusRejected;
      case 'closed': return l10n.statusClosed;
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.statusError;
      case 'acknowledged': return AppColors.statusWarning;
      case 'in_progress': return AppColors.statusWarning;
      case 'resolved': return AppColors.statusSuccess;
      case 'rejected': return AppColors.statusError;
      case 'closed': return AppColors.textSecondaryLight;
      default: return AppColors.textSecondaryLight;
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

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: AppDimensions.spacingM),
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.location_city,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            l10n.myReports,
            style: AppTypography.headline3.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.drafts_outlined, color: Colors.white),
          onPressed: () => context.pushNamed(RouteConstants.draftsRouteName),
          tooltip: l10n.drafts,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => context.pushNamed(RouteConstants.searchReportsRouteName),
          ),
        ),
      ],
    );
  }
}
