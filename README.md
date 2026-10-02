# Reclaim

App Flutter de "modo enfoque": convierte el celular en herramienta de aprendizaje.
Arquitectura: Clean Architecture feature-first · Riverpod · GoRouter · Repository Pattern.

## Primer arranque (tu Lección 1)
```bash
# 1. Instala Flutter (https://docs.flutter.dev/get-started/install/macos) y Xcode
flutter doctor

# 2. Genera las carpetas de plataforma SIN tocar lib/ ni pubspec.yaml
flutter create --org com.reclaim --project-name reclaim --platforms=ios,android .

flutter pub get
flutter test
open -a Simulator && flutter run
```

## Estructura
- `lib/core`: tema, rutas, constantes (storage/utils vendrán después)
- `lib/features/<feature>/{domain,data,presentation}`
- `lib/shared`: widgets y modelos reutilizables
- `docs/PLATAFORMAS.md`: qué permiten Android e iOS · `docs/RUTA_DE_APRENDIZAJE.md`

Estado actual: shell de navegación, tema oscuro, botón central con temporizador (Riverpod),
contrato `AppBlockerService` + canal nativo (sin implementación nativa aún).
