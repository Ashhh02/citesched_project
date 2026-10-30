import 'package:citesched_server/src/services/nlp_service.dart';
import 'package:test/test.dart';

void main() {
  group('NLPService pure helpers', () {
    test('normalizes queries', () {
      expect(
        NLPService.normalizeQueryForTest('  Schedule, Today!!  '),
        'schedule today',
      );
    });

    test('detects forbidden keywords', () {
      expect(
        NLPService.containsForbiddenKeywordsForTest('delete database now'),
        isTrue,
      );
      expect(
        NLPService.containsForbiddenKeywordsForTest('show my timetable'),
        isFalse,
      );
    });

    test('parses time tokens', () {
      expect(NLPService.parseTimeTokenForTest('8:30 am'), 510);
      expect(NLPService.parseTimeTokenForTest('12 pm'), 12 * 60);
      expect(NLPService.parseTimeTokenForTest('12 am'), 0);
    });

    test('extracts simple time ranges', () {
      final between = NLPService.extractTimeRangeForTest(
        'between 8 am and 10 am',
      );
      expect(between, isNotNull);
      expect(between!.start, 8 * 60);
      expect(between.end, 10 * 60);

      final morning = NLPService.extractTimeRangeForTest('morning classes');
      expect(morning, isNotNull);
      expect(morning!.start, 7 * 60);
      expect(morning.end, 12 * 60);
    });

    test('sanitizes Markdown from AI responses', () {
      final response = NLPService().sanitizeResponseText(
        'Here are the schedules for Monday:\n'
        '*  **10:00 AM - 12:00 PM:**\n'
        '   *  Section: 2B, Subject: IT 204',
      );

      expect(response, contains('• 10:00 AM - 12:00 PM:'));
      expect(response, contains('• Section: 2B, Subject: IT 204'));
      expect(response, isNot(contains('**')));
      expect(response, isNot(contains('* ')));
    });
  });
}
