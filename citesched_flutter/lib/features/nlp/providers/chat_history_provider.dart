import 'package:citesched_client/citesched_client.dart';
import 'package:citesched_flutter/features/auth/providers/auth_provider.dart';
import 'package:citesched_flutter/main.dart';
import 'package:citesched_flutter/core/providers/session_cache_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String? _activeRole(Ref ref) {
  return ref.read(authProvider.notifier).selectedRole;
}

final chatHistoryProvider = FutureProvider.family<List<ChatHistory>, int>((
  ref,
  limit,
) async {
  ref.watch(sessionCacheRevisionProvider);
  final activeRole = _activeRole(ref);
  return await client.chatHistory.getMyHistory(
    role: activeRole,
    limit: limit,
  );
});

final chatHistorySessionsProvider =
    FutureProvider.family<List<ChatSessionSummary>, int>((
  ref,
  limit,
) async {
  ref.watch(sessionCacheRevisionProvider);
  final activeRole = _activeRole(ref);
  return await client.chatHistory.getMySessions(
    role: activeRole,
    limit: limit,
  );
});

final chatHistorySessionProvider =
    FutureProvider.family<List<ChatHistory>, String>((
  ref,
  sessionId,
) async {
  ref.watch(sessionCacheRevisionProvider);
  final activeRole = _activeRole(ref);
  return await client.chatHistory.getSessionHistory(
    sessionId: sessionId,
    role: activeRole,
    limit: 200,
  );
});

final chatHistoryDeleteProvider = FutureProvider.family<bool, String>((
  ref,
  sessionId,
) async {
  ref.watch(sessionCacheRevisionProvider);
  return await client.nLP.deleteChatSession(
    sessionId: sessionId,
    role: _activeRole(ref),
  );
});
