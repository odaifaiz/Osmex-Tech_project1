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
      return _buildErrorPlaceholder();
    }

    // ✅ 1. Check if it's a local file path (Strict Rule: Local First)
    if (imageUrl!.startsWith('file://') || !imageUrl!.startsWith('http')) {
      final cleanPath = imageUrl!.replaceAll('file://', '');
      final file = File(cleanPath);
      
      if (file.existsSync()) {
        return _buildClip(
          child: Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
          ),
        );
      }
    }

    // ✅ 2. Fallback to Network with Caching
    return _buildClip(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildLoadingShimmer(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
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

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        errorIcon ?? Icons.image_not_supported_outlined,
        color: AppColors.textHint,
        size: (width != null && width! < 50) ? 20 : 32,
      ),
    );
  }
}
