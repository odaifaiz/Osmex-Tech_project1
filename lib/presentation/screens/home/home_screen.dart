// lib/presentation/screens/home/home_screen.dart

import 'package:city_fix_app/presentation/widgets/cards/stats_card.dart';
import 'package:city_fix_app/presentation/widgets/cards/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        context.pushNamed(RouteConstants.myReportsRouteName);
        break;
      case 2:
        context.pushNamed(RouteConstants.mapRouteName);
        break;
      case 3:
        context.pushNamed(RouteConstants.settingsRouteName);
        break;
    }
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
    if (difference.inDays == 0) return l10n.today;
    if (difference.inDays == 1) return l10n.yesterday;
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final userName = currentUser?.fullName?.split(' ').first ??
        currentUser?.email.split('@').first ??
        'User';

    final userReportsAsync = ref.watch(userReportsProvider(null));
    final userStatsAsync = ref.watch(userStatsProvider); // ✅ Use Async version if exists or handle state

    return Scaffold(
      appBar: _buildAppBar(context, userName, l10n),
      body: _buildFixedContent(context, userStatsAsync, userReportsAsync, l10n),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        onPressed: () {
          context.pushNamed(RouteConstants.createReportRouteName);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFixedContent(
    BuildContext context,
    AsyncValue<Map<String, int>> statsAsync,
    AsyncValue<List<dynamic>> reportsAsync,
    AppLocalizations l10n,
  ) {
    // ✅ Fix: Column instead of Expanded to prevent direct Scaffold body crash
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.spacingM),

        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL),
          child: _buildStatsSection(statsAsync),
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL),
          child: _buildRecentReportsHeader(context, l10n),
        ),
        const SizedBox(height: AppDimensions.spacingM),

        // ✅ Fixed: Only this part is Expanded inside the Column
        Expanded(child: _buildScrollableReportsList(context, reportsAsync, l10n)),
      ],
    );
  }

  Widget _buildRecentReportsHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.recentReports,
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        TextButton(
          onPressed: () => context.pushNamed(RouteConstants.myReportsRouteName),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.viewAll, style: AppTypography.link),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: AppTypography.link.color),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableReportsList(BuildContext context, AsyncValue<List<dynamic>> reportsAsync, AppLocalizations l10n) {
    return reportsAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return Center(child: _buildEmptyReports(context, l10n));
        }
        final recentReports = reports.take(5).toList();
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL),
          itemCount: recentReports.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDimensions.spacingM),
          itemBuilder: (context, index) {
            final report = recentReports[index];
            return ReportCard(
              title: report.title,
              status: _getStatusText(context, report.status),
              statusColor: _getStatusColor(report.status),
              date: _formatDate(context, report.createdAt),
              imageUrl: report.imageUrls?.isNotEmpty == true
                  ? report.imageUrls!.first
                  : '',
              onTap: () {
                context.pushNamed(
                  RouteConstants.reportDetailsRouteName,
                  extra: report.id,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (error, _) => Center(child: _buildErrorReports(context, error.toString(), l10n)),
    );
  }

  Widget _buildStatsSection(AsyncValue<Map<String, int>> statsAsync) {
    return statsAsync.when(
      data: (stats) {
        final total = stats['total'] ?? 0;
        final resolved = stats['resolved'] ?? 0;
        final inProgress = stats['inProgress'] ?? 0;

        return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimensions.spacingM,
          mainAxisSpacing: AppDimensions.spacingM,
          childAspectRatio: 0.85,
          children: [
            StatsCard(value: '$total', icon: Icons.inventory_2_outlined),
            StatsCard(
                value: '$resolved',
                icon: Icons.workspace_premium_outlined),
            StatsCard(
                value: '$inProgress',
                icon: Icons.hourglass_bottom_outlined),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (_, __) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 0.85,
        children: const [
          StatsCard(value: '0', icon: Icons.inventory_2_outlined),
          StatsCard(value: '0', icon: Icons.workspace_premium_outlined),
          StatsCard(value: '0', icon: Icons.hourglass_bottom_outlined),
        ],
      ),
    );
  }

  Widget _buildEmptyReports(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.inbox_outlined,
            size: 60, color: AppColors.inputLight),
        const SizedBox(height: 12),
        Text(l10n.noReports,
            style: AppTypography.body1
                .copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 6),
        Text(l10n.createFirstReport,
            style: AppTypography.caption.copyWith(color: AppColors.textHint)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () =>
              context.pushNamed(RouteConstants.createReportRouteName),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.createReport),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorReports(BuildContext context, String error, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 60, color: AppColors.statusError),
        const SizedBox(height: 12),
        Text(l10n.retry,
            style: AppTypography.body1
                .copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 6),
        Text(error,
            style: AppTypography.caption.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            ref.invalidate(userReportsProvider(null));
            ref.invalidate(userStatsProvider);
          },
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(l10n.retry),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String userName, AppLocalizations l10n) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png',
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.location_city,
                  color: AppColors.primary,
                  size: 28)),
          const SizedBox(width: AppDimensions.spacingS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.welcome(userName),
                style: AppTypography.headline3.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              Text(
                l10n.communityBetter,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondaryLight),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () =>
                context.pushNamed(RouteConstants.notificationsRouteName),
          ),
          IconButton(
            icon:
                const Icon(Icons.person_outline_rounded, size: 26),
            onPressed: () =>
                context.pushNamed(RouteConstants.profileRouteName),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: AppColors.borderDark, height: 1.0),
      ),
    );
  }
}
