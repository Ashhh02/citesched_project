String plainTextAiResponse(String text) {
  final lines = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
  final result = <String>[];

  for (var line in lines) {
    var cleaned = line.trimRight();
    final trimmed = cleaned.trim();
    if (trimmed.startsWith('```') ||
        RegExp(r'^(?:-{3,}|\*{3,}|_{3,})$').hasMatch(trimmed) ||
        RegExp(r'^\|?\s*:?-{3,}:?\s*(?:\|\s*:?-{3,}:?\s*)+\|?$')
            .hasMatch(trimmed)) {
      continue;
    }

    cleaned = cleaned.replaceFirst(RegExp(r'^\s{0,3}#{1,6}\s+'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^\s*>\s?'), '');
    cleaned = cleaned.replaceFirst(
      RegExp(r'^\s*[-*+]\s+'),
      '• ',
    );
    cleaned = cleaned.replaceFirst(
      RegExp(r'^\s*(\d+)[.)]\s+'),
      r'$1. ',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'!\[([^\]]*)\]\([^)]+\)'),
      (match) => match[1] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^)]+\)'),
      (match) => match[1] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(\*\*|__)(.+?)\1'),
      (match) => match[2] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(?<![\w])(\*|_)(.+?)\1(?!\w)'),
      (match) => match[2] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'~~(.+?)~~'),
      (match) => match[1] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(`+)(.+?)\1'),
      (match) => match[2] ?? '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'\*{1,2}|_{1,2}|~~|`+'), '');
    if (cleaned.contains('|')) {
      final cells = cleaned.trim().split('|');
      if (cells.first.trim().isEmpty) cells.removeAt(0);
      if (cells.isNotEmpty && cells.last.trim().isEmpty) cells.removeLast();
      cleaned = cells.map((cell) => cell.trim()).join(' — ');
    }

    result.add(cleaned);
  }

  return result.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}
