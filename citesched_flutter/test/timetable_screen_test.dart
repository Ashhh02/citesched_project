import 'package:citesched_client/citesched_client.dart';
import 'package:citesched_flutter/features/admin/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  test('timetable summary reuses the filtered schedules cache', () async {
    final now = DateTime.utc(2026, 1, 1);
    final container = ProviderContainer(
      overrides: [
        filteredSchedulesProvider.overrideWith(
          (ref) async => [
            ScheduleInfo(
              schedule: Schedule(
                subjectId: 7,
                facultyId: 3,
                section: 'A',
                units: 3,
                timeslot: Timeslot(
                  day: DayOfWeek.mon,
                  startTime: '08:00',
                  endTime: '09:30',
                  label: 'Morning',
                  createdAt: now,
                  updatedAt: now,
                ),
                createdAt: now,
                updatedAt: now,
              ),
              conflicts: [],
            ),
          ],
        ),
      ],
    );
    addTearDown(container.dispose);

    final summary = await container.read(timetableSummaryProvider.future);

    expect(summary.totalSubjects, 1);
    expect(summary.totalUnits, 3);
    expect(summary.totalWeeklyHours, 1.5);
    expect(summary.conflictCount, 0);
  });

  testWidgets('Timetable screen renders header and summary', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
    final summary = TimetableSummary(
      totalSubjects: 0,
      totalUnits: 0,
      totalWeeklyHours: 0,
      conflictCount: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          filteredSchedulesProvider.overrideWith(
            (ref) async => <ScheduleInfo>[],
          ),
          timetableSummaryProvider.overrideWith((ref) async => summary),
        ],
        child: MaterialApp(
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: const TextScaler.linear(0.85),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const TimetableScreen(
            initialMetadata: TimetableMetadata(
              facultyList: [],
              roomList: [],
            ),
            skipMetadataLoad: true,
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Weekly Timetable'), findsWidgets);
    expect(find.text('GENERATE AI SCHEDULE'), findsOneWidget);
  });
}
