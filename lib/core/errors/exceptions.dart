// lib/core/errors/exceptions.dart

/// Thrown when a network request fails (no internet, timeout, etc.)
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'لا يوجد اتصال بالإنترنت']);
  @override
  String toString() => message;
}

/// Thrown when a Supabase / remote DB operation fails
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

/// Thrown when a local DB (Drift/SQLite) operation fails
class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException(this.message);
  @override
  String toString() => message;
}

/// Thrown when the user is not authenticated and a protected operation is attempted
class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'يجب تسجيل الدخول أولاً']);
  @override
  String toString() => message;
}

/// Thrown when input validation fails
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
  @override
  String toString() => message;
}

/// Thrown when a resource is not found (locally or remotely)
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'لم يتم العثور على العنصر المطلوب']);
  @override
  String toString() => message;
}

/// Thrown when a sync operation conflicts with remote data
class SyncConflictException implements Exception {
  final String message;
  final String? localId;
  final String? remoteId;
  const SyncConflictException(this.message, {this.localId, this.remoteId});
  @override
  String toString() => message;
}
