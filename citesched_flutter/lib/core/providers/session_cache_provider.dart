import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionCacheRevisionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final sessionCacheRevisionProvider =
    NotifierProvider<SessionCacheRevisionNotifier, int>(
      SessionCacheRevisionNotifier.new,
    );
