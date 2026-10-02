import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/focus_durations.dart';
import '../../../core/theme/app_theme.dart';
import '../../focus/presentation/focus_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focus = ref.watch(focusControllerProvider);
    final controller = ref.read(focusControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            focus.isActive ? 'Enfocado' : 'Listo para enfocarte',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const Spacer(),
          _FocusButton(
            active: focus.isActive,
            progress: focus.progress,
            label: focus.isActive
                ? _format(focus.remaining)
                : FocusDurations.label(focus.selected),
            onTap: focus.isActive ? controller.stop : controller.start,
          ),
          const Spacer(),
          if (!focus.isActive)
            Wrap(
              spacing: 8,
              children: [
                for (final d in FocusDurations.presets)
                  ChoiceChip(
                    label: Text(FocusDurations.label(d)),
                    selected: focus.selected == d,
                    onSelected: (_) => controller.selectDuration(d),
                  ),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}

class _FocusButton extends StatelessWidget {
  const _FocusButton({
    required this.active,
    required this.progress,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final double progress;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? accent.withValues(alpha: 0.15) : AppColors.surface,
          border: Border.all(color: accent, width: active ? 3 : 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: active ? 0.35 : 0.12),
              blurRadius: active ? 48 : 24,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (active)
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(value: progress, strokeWidth: 3),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 4),
                Text(active ? 'Toca para salir' : 'Toca para iniciar',
                    style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
