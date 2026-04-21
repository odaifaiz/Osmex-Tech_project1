// lib/core/network/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Monitors device connectivity in real time.
/// Exposes a [Stream<bool>] (true = online) and a synchronous [isOnline] getter.
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  //قراءة مباشرة
  bool get isOnline => _isOnline;

  //قراءة تفاعلية
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Call once from [main] before runApp.
  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final online = _isConnected(results);
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(_isOnline);
      }
    });
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

// ─── Riverpod Providers ───────────────────────────────────────────────────────

/// Singleton connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});




/// Reactive boolean: true = device is online
final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  // Emit the current value first, then stream changes
  return (() async* {
    yield service.isOnline;
    yield* service.onConnectivityChanged;
  })();
});

/// Synchronous read: use in non-reactive contexts
final isOnlineSyncProvider = Provider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).isOnline;
});
