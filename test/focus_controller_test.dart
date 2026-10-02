import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclaim/features/app_blocker/app_blocker_providers.dart';
import 'package:reclaim/features/app_blocker/domain/app_blocker_service.dart';
import 'package:reclaim/features/focus/presentation/focus_controller.dart';

class FakeBlocker implements AppBlockerService {
  bool blocking = false;
  @override
  Future<bool> hasPermission() async => true;
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> startBlocking(Duration duration) async => blocking = true;
  @override
  Future<void> stopBlocking() async => blocking = false;
}

void main() {
  test('start activa el bloqueo y stop lo desactiva', () async {
    final blocker = FakeBlocker();
    final container = ProviderContainer(
      overrides: [appBlockerServiceProvider.overrideWithValue(blocker)],
    );
    addTearDown(container.dispose);

    final controller = container.read(focusControllerProvider.notifier);
    await controller.start();
    expect(container.read(focusControllerProvider).isActive, isTrue);
    expect(blocker.blocking, isTrue);

    await controller.stop();
    expect(container.read(focusControllerProvider).isActive, isFalse);
    expect(blocker.blocking, isFalse);
  });
}
