import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  timeout: const Duration(minutes: 10),
  responseDataCallback: (data) async {
    final screenshots = Map<String, String>.from(data?['screenshots'] as Map);
    final validPath = RegExp(r'^(light|dark)/[0-9]{2}-[a-z-]+\.png$');
    for (final theme in ['light', 'dark']) {
      final frames = screenshots.keys.where((key) => key.startsWith('$theme/'));
      if (frames.length != 57 || !frames.every(validPath.hasMatch)) {
        throw StateError('Expected 57 valid $theme screenshots.');
      }
    }
    for (final entry in screenshots.entries) {
      if (!validPath.hasMatch(entry.key)) {
        throw StateError('Unexpected screenshot path');
      }
      final file = File('screenshots/${entry.key}');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(base64Decode(entry.value));
    }
  },
);
