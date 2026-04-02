// lib/core/utils/validators.dart

/// A class containing static methods for validating form fields.
class Validators {
  // This class is not meant to be instantiated.
  Validators._();

  /// Validates that the value is not empty.
  static String? notEmpty(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates an email address.
  static String? email(String? value, {String message = 'Enter a valid email address'}) {
    final emptyValidation = notEmpty(value);
    if (emptyValidation != null) {
      return emptyValidation;
    }
    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value!)) {
      return message;
    }
    return null;
  }

  /// Validates a password.
  /// It must be at least 8 characters long.
  static String? password(String? value, {String message = 'Password must be at least 8 characters long'}) {
    final emptyValidation = notEmpty(value);
    if (emptyValidation != null) {
      return emptyValidation;
    }
    if (value!.length < 8) {
      return message;
    }
    return null;
  }

  /// Validates that two values are the same (e.g., password and confirm password).
  static String? confirmPassword(String? password, String? confirmPassword, {String message = 'Passwords do not match'}) {
    final emptyValidation = notEmpty(confirmPassword);
    if (emptyValidation != null) {
      return emptyValidation;
    }
    if (password != confirmPassword) {
      return message;
    }
    return null;
  }

  /// Validates a phone number.
  /// Basic validation for 9 to 15 digits.
  static String? phone(String? value, {String message = 'Enter a valid phone number'}) {
    final emptyValidation = notEmpty(value);
    if (emptyValidation != null) {
      return emptyValidation;
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(value!)) {
      return message;
    }
    return null;
  }
}
