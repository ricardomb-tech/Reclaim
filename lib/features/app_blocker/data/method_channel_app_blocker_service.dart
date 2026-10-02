import 'package:flutter/services.dart';

import '../domain/app_blocker_service.dart';

/// Puente Flutter <-> nativo. Mientras no exista código Kotlin/Swift,
/// los métodos devuelven valores seguros (MissingPluginException).
class MethodChannelAppBlockerService implements AppBlockerService {
  static const _channel = MethodChannel('reclaim/app_blocker');

  @override
  Future<bool> hasPermission() async =>
      await _invoke<bool>('hasPermission') ?? false;

  @override
  Future<bool> requestPermission() async =>
      await _invoke<bool>('requestPermission') ?? false;

  @override
  Future<void> startBlocking(Duration duration) =>
      _invoke<void>('startBlocking', {'seconds': duration.inSeconds});

  @override
  Future<void> stopBlocking() => _invoke<void>('stopBlocking');

  Future<T?> _invoke<T>(String method, [Object? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null; // lado nativo aún no implementado
    }
  }
}
