import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:erabook/core/theme.dart';
import 'package:erabook/data/mock_data.dart';

void main() {
  test('design tokens use Urbanist and brand primary', () {
    final style = ts(16, weight: FontWeight.w700);
    expect(style.fontFamily, 'Urbanist');
    expect(buildTheme(Brightness.light).colorScheme.primary, C.primary);
  });

  test('mock catalog is consistent', () {
    expect(books.isNotEmpty, true);
    expect(bk('hp7').title, contains('Harry Potter'));
    expect(
      homeFeatured.every((b) => b.cover.startsWith('assets/covers/')),
      true,
    );
  });
}
