import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/method_channel_app_blocker_service.dart';
import 'domain/app_blocker_service.dart';

final appBlockerServiceProvider = Provider<AppBlockerService>(
  (ref) => MethodChannelAppBlockerService(),
);
