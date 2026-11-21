import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the domain layer has no Flutter imports', () {
    final dir = Directory('lib/domain');
    expect(dir.existsSync(), isTrue);
    final offenders = <String>[];
    for (final f in dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      final src = f.readAsStringSync();
      if (RegExp(r'''import\s+['"](package:flutter|dart:ui)''').hasMatch(src)) offenders.add(f.path);
    }
    expect(offenders, isEmpty);
  });
}
