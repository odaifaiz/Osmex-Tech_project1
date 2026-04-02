// lib/core/theme/app_dimensions.dart

/// A class that holds all the dimensions for the app,
/// like padding, margin, radius, and spacing.
class AppDimensions {
  // This class is not meant to be instantiated.
  AppDimensions._();

  // --- General Spacing ---
  static const double spacingXXS = 4.0;  // Extra extra small
  static const double spacingXS = 8.0;   // Extra small
  static const double spacingS = 12.0;   // Small
  static const double spacingM = 16.0;   // Medium (Default)
  static const double spacingL = 20.0;   // Large
  static const double spacingXL = 24.0;  // Extra large
  static const double spacingXXL = 32.0; // Extra extra large

  // --- Padding ---
  static const double paddingPageHorizontal = spacingL;
  static const double paddingPageVertical = spacingXL;
  static const double paddingCard = spacingM;
  static const double paddingInput = spacingM;

  // --- Border Radius ---
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 50.0; // For circular buttons

  // --- Icon Sizes ---
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;

  // --- Other ---
  static const double buttonHeight = 52.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 70.0;
  static const double dividerThickness = 1.0;
}
