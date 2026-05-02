// lib/presentation/screens/profile/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/utils/extensions.dart';
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
    final colors = context.appColors;
    final currentUser = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(userStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    final displayName = currentUser?.fullName ?? '---';
    final email = currentUser?.email ?? '---';
    final phone = currentUser?.phoneNumber ?? '---';
    final avatarUrl = currentUser?.photoURL;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile,
          style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.pushNamed(RouteConstants.editProfileRouteName);
            },
            child: Text(
              l10n.edit,
              style: AppTypography.link.copyWith(fontWeight: FontWeight.w600, color: colors.primary),
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
              context.goNamed(RouteConstants.homeRouteName);
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
        backgroundColor: colors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            _buildProfileAvatar(context, avatarUrl, colors),
            const SizedBox(height: AppDimensions.spacingM),

            Text(
              displayName,
              style: AppTypography.headline3.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              email,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),

            _buildStatsRow(statsAsync, l10n, colors),
            const SizedBox(height: AppDimensions.spacingXL),

            Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: colors.border.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                children: [
                  _buildInfoRow(context: context, label: l10n.fullName, value: displayName, colors: colors),
                  Divider(color: colors.divider, height: 32),
                  _buildInfoRow(
                    context: context,
                    label: l10n.phoneNumber,
                    value: phone.isEmpty ? '---' : phone,
                    colors: colors,
                  ),
                  Divider(color: colors.divider, height: 32),
                  _buildInfoRow(context: context, label: l10n.email, value: email, colors: colors),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildLogoutButton(ref, context, l10n, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, String? avatarUrl, AppColors colors) {
    final avatarSize = context.isTablet ? 150.0 : (context.isSmallScreen ? 100.0 : 120.0);
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            colors.primary.withOpacity(0.3),
            colors.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colors.primary.withOpacity(0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
              child: _buildAvatarImage(avatarUrl, colors),
            )
          : Icon(Icons.person, size: 60, color: colors.primary),
    );
  }

  Widget _buildAvatarImage(String url, AppColors colors) {
    final isLocal = url.startsWith('file://') || url.startsWith('/') || !url.startsWith('http');
    
    if (isLocal) {
      return Image.file(
        File(url.replaceAll('file://', '')),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 60, color: colors.primary),
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 60, color: colors.primary),
      );
    }
  }

  Widget _buildStatsRow(AsyncValue<Map<String, int>> statsAsync, AppLocalizations l10n, AppColors colors) {
    return statsAsync.when(
      data: (stats) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('${stats['total'] ?? 0}', l10n.totalReports, colors),
            _buildStatDivider(colors),
            _buildStatItem('${stats['resolved'] ?? 0}', l10n.resolved, colors),
            _buildStatDivider(colors),
            _buildStatItem('${stats['inProgress'] ?? 0}', l10n.statusInProgress, colors),
          ],
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(color: colors.primary)),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(String value, String label, AppColors colors) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headline3
              .copyWith(color: colors.primary, fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(label,
            style:
            AppTypography.caption.copyWith(color: colors.textSecondary)),
      ],
    );
  }

  Widget _buildStatDivider(AppColors colors) {
    return Container(height: 40, width: 1, color: colors.border.withOpacity(0.3));
  }

  Widget _buildInfoRow({required BuildContext context, required String label, required String value, required AppColors colors}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.isSmallScreen ? 90 : 110,
          child: Text(
            label,
            style: AppTypography.body2.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body1.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(WidgetRef ref, BuildContext context, AppLocalizations l10n, AppColors colors) {
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
              backgroundColor: colors.surface,
              title: Text(l10n.logoutConfirmTitle, style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
              content: Text(
                  l10n.logoutConfirmMessage,
                  style: AppTypography.body2.copyWith(color: colors.textSecondary)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel, style: TextStyle(color: colors.textPrimary))),
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.logout,
                        style: TextStyle(
                            color: colors.error))),
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
        icon: Icon(Icons.logout, color: colors.error),
        label: Text(l10n.logout,
            style: AppTypography.body1
                .copyWith(color: colors.error)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.error),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}