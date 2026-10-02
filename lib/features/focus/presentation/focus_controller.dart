import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_blocker/app_blocker_providers.dart';
import '../domain/focus_state.dart';

final focusControllerProvider =
    NotifierProvider<FocusController, FocusState>(FocusController.new);

class FocusController extends Notifier<FocusState> {
  Timer? _ticker;

  @override
  FocusState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const FocusState();
  }

  void selectDuration(Duration d) {
    if (state.isActive) return;
    state = state.copyWith(selected: d);
  }

  Future<void> start() async {
    if (state.isActive) return;
    state = state.copyWith(
      status: FocusStatus.active,
      remaining: state.selected,
    );
    await ref.read(appBlockerServiceProvider).startBlocking(state.selected);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> stop() async {
    _ticker?.cancel();
    state = state.copyWith(status: FocusStatus.idle, remaining: Duration.zero);
    await ref.read(appBlockerServiceProvider).stopBlocking();
  }

  void _tick() {
    final next = state.remaining - const Duration(seconds: 1);
    if (next <= Duration.zero) {
      stop(); // sesión completada
    } else {
      state = state.copyWith(remaining: next);
    }
  }
}
