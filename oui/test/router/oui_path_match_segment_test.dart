import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiPathMatchSegment', () {
    test('constructor initializes fields correctly', () {
      final segment = OuiPathSegment.static('home');
      final matchSegment = OuiPathMatchSegment(
        segment: segment,
        original: 'home',
        value: 'home',
      );

      expect(matchSegment.segment, segment);
      expect(matchSegment.original, 'home');
      expect(matchSegment.content, 'home');
      expect(matchSegment.id, 'home');
    });

    test('content returns original if value is null', () {
      final segment = OuiPathSegment.static('home');
      final matchSegment = OuiPathMatchSegment(
        segment: segment,
        original: 'home',
      );

      expect(matchSegment.content, 'home');
    });

    test('content returns value if not null', () {
      final segment = OuiPathSegment.static('home');
      final matchSegment = OuiPathMatchSegment(
        segment: segment,
        original: 'home',
        value: 'home-value',
      );

      expect(matchSegment.content, 'home-value');
    });

    test('id returns segment id', () {
      final segment = OuiPathSegment.static('home');
      final matchSegment = OuiPathMatchSegment(
        segment: segment,
        original: 'home',
      );

      expect(matchSegment.id, 'home');
    });
  });
}
