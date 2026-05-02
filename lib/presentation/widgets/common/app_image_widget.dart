// lib/presentation/widgets/common/app_image_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData? errorIcon;

  const AppImageWidget({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.errorIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorPlaceholder(context);
    }

    final isLocal = imageUrl!.startsWith('file://') || 
                   imageUrl!.startsWith('/') || 
                   !imageUrl!.startsWith('http');

    if (isLocal) {
      final cleanPath = imageUrl!.replaceAll('file://', '');
      return _buildClip(
        child: Image.file(
          File(cleanPath),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ [AppImageWidget] Error loading local file: $cleanPath');
            return _buildErrorPlaceholder(context);
          },
        ),
      );
    }

    return _buildClip(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildLoadingShimmer(context),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(context),
      ),
    );
  }

  Widget _buildClip({required Widget child}) {
    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      );
    }
    return child;
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.border.withOpacity(0.5),
      highlightColor: colors.surface,
      child: Container(
        width: width,
        height: height,
        color: colors.surface,
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.input,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        errorIcon ?? Icons.image_not_supported_outlined,
        color: colors.textHint,
        size: (width != null && width! < 50) ? 20 : 32,
      ),
    );
  }
}
