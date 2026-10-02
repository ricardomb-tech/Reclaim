# Qué se puede (y qué no) bloquear: Android vs iOS

**Flutter por sí solo NO puede bloquear otras apps.** Todo el bloqueo es código nativo,
expuesto a Dart por un `MethodChannel` (`reclaim/app_blocker`).

## Android (Kotlin) — flexible, pero con permisos delicados
| Necesidad | API | Permiso |
|---|---|---|
| Saber qué app está en primer plano / tiempo de uso | `UsageStatsManager` | `PACKAGE_USAGE_STATS` (el usuario lo concede en Ajustes) |
| Reaccionar cuando se abre una app bloqueada | `AccessibilityService` (evento `TYPE_WINDOW_STATE_CHANGED`) | Servicio de accesibilidad activado a mano |
| Mostrar pantalla motivacional encima | Activity propia lanzada desde el servicio, u overlay | `SYSTEM_ALERT_WINDOW` (si overlay) |
| Mantener el modo vivo en segundo plano | Foreground Service + notificación | `FOREGROUND_SERVICE`, `POST_NOTIFICATIONS` |
| Listar apps instaladas | `PackageManager` | `QUERY_ALL_PACKAGES` (Google Play lo restringe: justificar) |
| Bloqueo "real" del sistema | Device Owner / Lock Task | Solo dispositivos gestionados: **no viable** para MVP |

Es *bloqueo reactivo*: la app detecta la apertura y la tapa. Riesgo: Google Play revisa
con lupa el uso de AccessibilityService (declaración de uso obligatoria).

## iOS (Swift) — seguro, pero cerrado
iOS **no** permite detectar qué app usa el usuario ni tapar otras apps. La única vía es
**Screen Time API** (iOS 16+):
- `FamilyControls`: autorización + `FamilyActivityPicker` (el usuario elige apps; Apple
  devuelve *tokens* opacos, nunca los bundle IDs → no se puede listar apps por categoría propia).
- `ManagedSettings`: `ManagedSettingsStore.shield.applications = tokens` bloquea con un escudo del sistema.
- `DeviceActivity`: programar el inicio/fin del bloqueo (corre en una **App Extension**, aunque la app esté cerrada).
- `ShieldConfiguration` extension: personalizar el texto del escudo (mensaje motivacional, limitado).

Requisitos: entitlement `com.apple.developer.family-controls` (solicitud a Apple; en desarrollo
funciona, para App Store se aprueba aparte), dispositivo **real** (no simulador), 3 targets
en Xcode (app + DeviceActivityMonitor + ShieldConfiguration) y App Group para compartir datos.
La pantalla propia de "Reclaim" al intentar abrir una app bloqueada **no es posible** en iOS: solo el shield del sistema.

## Consecuencias de diseño
- `AppBlockerService` (dominio) es una interfaz; hay una implementación por canal y
  cada plataforma resuelve lo suyo. Los tests usan un fake.
- Las "categorías de apps permitidas" en iOS se traducen a la selección del picker; en
  Android a una lista de `packageName`. El modelo de dominio guarda un `AllowedAppSet` abstracto (lección futura).
- Hoja de ruta MVP: **Android primero** (más rápido de probar) y iOS con Screen Time después.
  Como tu meta es aprender con Xcode, haremos iOS en paralelo desde la Lección 4.
