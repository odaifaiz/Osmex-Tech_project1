// lib/presentation/screens/profile/profile_screen.dart

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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(userStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    final displayName = currentUser?.fullName ?? '---';
    final email = currentUser?.email ?? '---';
    final phone = currentUser?.phoneNumber ?? '---';
    final avatarUrl = currentUser?.photoURL;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.pushNamed(RouteConstants.editProfileRouteName);
            },
            child: Text(
              l10n.edit,
              style: AppTypography.link.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          switch (index) {
            case 0:
              context.go('/${RouteConstants.homeRouteName}');
              break;
            case 1:
              context.pushNamed(RouteConstants.myReportsRouteName);
              break;
            case 2:
              context.pushNamed(RouteConstants.mapRouteName);
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteConstants.createReportRouteName);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            _buildProfileAvatar(avatarUrl),
            const SizedBox(height: AppDimensions.spacingM),

            Text(
              displayName,
              style: AppTypography.headline3.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              email,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),

            _buildStatsRow(statsAsync, l10n),
            const SizedBox(height: AppDimensions.spacingXL),

            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: AppColors.borderDefault),
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                children: [
                  _buildInfoRow(label: l10n.fullName, value: displayName),
                  const Divider(color: AppColors.borderDefault, height: 32),
                  _buildInfoRow(
                    label: l10n.phoneNumber,
                    value: phone.isEmpty ? '---' : phone,
                  ),
                  const Divider(color: AppColors.borderDefault, height: 32),
                  _buildInfoRow(label: l10n.email, value: email),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildLogoutButton(ref, context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? avatarUrl) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person,
              size: 60, color: AppColors.primary),
        ),
      )
          : const Icon(Icons.person, size: 60, color: AppColors.primary),
    );
  }

  Widget _buildStatsRow(AsyncValue<Map<String, int>> statsAsync, AppLocalizations l10n) {
    return statsAsync.when(
      data: (stats) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('${stats['total'] ?? 0}', l10n.totalReports),
            _buildStatDivider(),
            _buildStatItem('${stats['resolved'] ?? 0}', l10n.resolved),
            _buildStatDivider(),
            _buildStatItem('${stats['inProgress'] ?? 0}', l10n.statusInProgress),
          ],
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headline3
              .copyWith(color: AppColors.primary, fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(label,
            style:
            AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 40, width: 1, color: AppColors.borderDefault);
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(WidgetRef ref, BuildContext context, AppLocalizations l10n) {
    final isLoading = ref.watch(authLoadingProvider);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading
            ? null
            : () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.backgroundCard,
              title: Text(l10n.logoutConfirmTitle, style: AppTypography.headline3),
              content: Text(
                  l10n.logoutConfirmMessage,
                  style: AppTypography.body2),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel)),
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.logout,
                        style: const TextStyle(
                            color: AppColors.statusError))),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) {
              context.goNamed(RouteConstants.loginRouteName);
            }
          }
        },
        icon: const Icon(Icons.logout, color: AppColors.statusError),
        label: Text(l10n.logout,
            style: AppTypography.body1
                .copyWith(color: AppColors.statusError)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.statusError),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}