abstract final class FocusDurations {
  static const presets = <Duration>[
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
  ];

  static String label(Duration d) =>
      d.inMinutes >= 60 ? '${d.inHours} h' : '${d.inMinutes} min';
}
