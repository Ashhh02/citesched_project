import 'package:citesched_flutter/core/utils/session_context.dart';
import 'package:citesched_flutter/core/providers/session_cache_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('session cache revision can be advanced on account changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(sessionCacheRevisionProvider), 0);

    container.read(sessionCacheRevisionProvider.notifier).bump();

    expect(container.read(sessionCacheRevisionProvider), 1);
  });

  test('session-bound providers recompute after an account change', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sessionBoundValue = FutureProvider<int>((ref) async {
      return ref.watch(sessionCacheRevisionProvider);
    });

    expect(await container.read(sessionBoundValue.future), 0);

    container.read(sessionCacheRevisionProvider.notifier).bump();

    expect(await container.read(sessionBoundValue.future), 1);
  });

  group('SessionContext.fromJson', () {
    test('parses the authenticated account context', () {
      final context = SessionContext.fromJson({
        'authenticatedUserId': 'user-123',
        'email': 'faculty@example.edu',
        'userName': 'Faculty Member',
        'resolvedRole': 'faculty',
        'scopeNames': ['faculty', 'admin'],
      });

      expect(context.authenticatedUserId, 'user-123');
      expect(context.email, 'faculty@example.edu');
      expect(context.userName, 'Faculty Member');
      expect(context.resolvedRole, 'faculty');
      expect(context.scopeNames, ['faculty', 'admin']);
    });

    test('handles absent or malformed optional values', () {
      final context = SessionContext.fromJson({
        'email': null,
        'scopeNames': ['student', 1],
      });

      expect(context.authenticatedUserId, isNull);
      expect(context.email, isNull);
      expect(context.userName, isNull);
      expect(context.resolvedRole, isNull);
      expect(context.scopeNames, ['student']);
    });
  });
}
