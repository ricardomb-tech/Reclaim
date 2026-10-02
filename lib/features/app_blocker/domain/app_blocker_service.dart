/// Contrato del bloqueo de apps. El dominio NO sabe si es Kotlin o Swift.
abstract interface class AppBlockerService {
  /// ¿Tiene la app los permisos del sistema necesarios?
  Future<bool> hasPermission();

  /// Abre/solicita los permisos (Ajustes en Android, Screen Time en iOS).
  Future<bool> requestPermission();

  /// Empieza a restringir apps hasta [duration].
  Future<void> startBlocking(Duration duration);

  Future<void> stopBlocking();
}
