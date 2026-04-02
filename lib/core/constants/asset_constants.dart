// lib/core/constants/asset_constants.dart

/// A class that holds all the asset paths for the app.
/// This provides a centralized and type-safe way to access assets.
class AssetConstants {
  // This class is not meant to be instantiated.
  AssetConstants._();

  // --- Base Paths ---
  static const String _imagesPath = "assets/images";
  static const String _iconsPath = "assets/icons";
  // static const String _fontsPath = "assets/fonts";
  // static const String _translationsPath = "assets/translations";
  // static const String _lottiePath = "assets/lottie"; // Assuming you might add Lottie files

  // --- Images ---
  static const String logo = "$_imagesPath/logo.png";
  static const String onboarding1 = "$_imagesPath/onboarding_1.png";
  static const String onboarding2 = "$_imagesPath/onboarding_2.png";
  static const String onboarding3 = "$_imagesPath/onboarding_3.png";

  // --- Icons ---
  static const String appIcon = "$_iconsPath/app_icon.png";
  static const String splashIcon = "$_iconsPath/splash_icon.png";
  // Example for SVG icon if you add any
  // static const String homeIcon = "$_iconsPath/home.svg";

  // --- Fonts ---
  static const String fontTajawal = "Tajawal"; // The family name defined in pubspec.yaml
  static const String googleLogo = "$_iconsPath/google_logo.svg";


  // // --- Translations ---
  // static const String arTranslation = "$_translationsPath/ar.json";
  // static const String enTranslation = "$_translationsPath/en.json";
  
  // --- Lottie Animations (Examples) ---
  // static const String loadingAnimation = "$_lottiePath/loading.json";
  // static const String emptyStateAnimation = "$_lottiePath/empty.json";
}
