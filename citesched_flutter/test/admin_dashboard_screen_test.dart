import 'package:citesched_client/citesched_client.dart';
import 'package:citesched_flutter/features/admin/screens/admin_dashboard_screen.dart';
import 'package:citesched_flutter/features/admin/screens/admin_layout.dart';
import 'package:citesched_flutter/features/auth/providers/auth_provider.dart';
import 'package:citesched_flutter/core/widgets/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  UserInfo? build() => null;
}

DashboardStats _buildFakeStats() {
  return DashboardStats(
    totalSchedules: 12,
    totalFaculty: 5,
    totalStudents: 120,
    totalSubjects: 18,
    totalRooms: 9,
    totalConflicts: 0,
    facultyLoad: [
      FacultyLoadData(
        facultyName: 'Test Faculty',
        currentLoad: 9,
        maxLoad: 15,
      ),
    ],
    recentConflicts: [],
    sectionDistribution: [
      DistributionData(label: 'A', count: 10),
    ],
    yearLevelDistribution: [
      DistributionData(label: '1st', count: 10),
    ],
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Admin dashboard renders stats cards', (tester) async {
    final stats = _buildFakeStats();
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_FakeAuthNotifier.new),
          dashboardStatsProvider.overrideWith((ref) async => stats),
          pendingFacultyRequestsProvider.overrideWith(
            (ref) async => const <Faculty>[],
          ),
          recentStudentSignupsProvider.overrideWith(
            (ref) async => const <Student>[],
          ),
        ],
        child: const MaterialApp(
          home: AdminDashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('FACULTY'), findsOneWidget);
    expect(find.text('STUDENTS'), findsOneWidget);
    expect(find.text('SCHEDULES'), findsOneWidget);
    expect(find.text('CONFLICTS'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Admin layout adapts to available content width', (tester) async {
    final stats = _buildFakeStats();
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    for (final size in const [
      Size(1544, 900),
      Size(1000, 900),
      Size(390, 844),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(_FakeAuthNotifier.new),
            dashboardStatsProvider.overrideWith((ref) async => stats),
            pendingFacultyRequestsProvider.overrideWith(
              (ref) async => const <Faculty>[],
            ),
            recentStudentSignupsProvider.overrideWith(
              (ref) async => const <Student>[],
            ),
          ],
          child: const MaterialApp(home: AdminLayout()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('FACULTY'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Dashboard should not overflow at $size.',
      );
    }

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Draggable FAB handles a viewport smaller than the FAB', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(40, 40));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox.expand(
          child: Stack(
            children: [
              DraggableFab(
                child: SizedBox(width: 56, height: 56),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
