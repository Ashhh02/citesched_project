import 'package:citesched_client/citesched_client.dart';
import 'package:citesched_flutter/main.dart';
import 'package:citesched_flutter/core/providers/session_cache_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectsProvider = FutureProvider<List<Subject>>((ref) async {
  ref.watch(sessionCacheRevisionProvider);
  return await client.admin.getAllSubjects(isActive: true);
});
