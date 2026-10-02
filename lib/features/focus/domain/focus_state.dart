import '../../../core/constants/focus_durations.dart';

enum FocusStatus { idle, active }

class FocusState {
  const FocusState({
    this.status = FocusStatus.idle,
    this.selected = const Duration(minutes: 30),
    this.remaining = Duration.zero,
  });

  final FocusStatus status;
  final Duration selected;
  final Duration remaining;

  bool get isActive => status == FocusStatus.active;
  Duration get elapsed => selected - remaining;
  double get progress =>
      selected.inSeconds == 0 ? 0 : elapsed.inSeconds / selected.inSeconds;

  FocusState copyWith({
    FocusStatus? status,
    Duration? selected,
    Duration? remaining,
  }) =>
      FocusState(
        status: status ?? this.status,
        selected: selected ?? this.selected,
        remaining: remaining ?? this.remaining,
      );

  @override
  String toString() =>
      'FocusState($status, ${FocusDurations.label(selected)}, $remaining)';
}
