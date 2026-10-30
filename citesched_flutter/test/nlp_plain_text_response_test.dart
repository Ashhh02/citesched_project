import 'package:citesched_flutter/features/nlp/utils/plain_text_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts Markdown responses to readable plain text', () {
    expect(
      plainTextAiResponse(
        '## Schedule\n\n**Today** is `Monday`.\n- Room: [LAB 1](https://example.com)',
      ),
      'Schedule\n\nToday is Monday.\n• Room: LAB 1',
    );
  });

  test('preserves ordinary plain text', () {
    const response = 'Your next class starts at 9:00 AM in Room 101.';
    expect(plainTextAiResponse(response), response);
  });

  test('converts Markdown emphasis and tables to plain text', () {
    expect(
      plainTextAiResponse(
        '*Next class:* **IT101**\n\n| Day | Room |\n| --- | --- |\n| Monday | LAB 1 |',
      ),
      'Next class: IT101\n\nDay — Room\nMonday — LAB 1',
    );
  });

  test('cleans schedule lists formatted like generated AI responses', () {
    final response = plainTextAiResponse(
      'Here are the schedules for Monday:\n'
      '*  **10:00 AM - 12:00 PM:**\n'
      '   *  Section: 2B, Subject: IT 204, Faculty: Arvin, Room: ROOM 1\n'
      '*  **08:00 AM - 10:00 AM:**\n'
      '   *  Section: 2A, Subject: IT 204, Faculty: Arvin, Room: ROOM 1',
    );

    expect(response, contains('• 10:00 AM - 12:00 PM:'));
    expect(response, contains('• Section: 2B, Subject: IT 204'));
    expect(response, contains('• 08:00 AM - 10:00 AM:'));
    expect(response, isNot(contains('**')));
    expect(response, isNot(contains('* ')));
  });
}
