import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/router/oui_path.dart';

import '../screens/screen_testing_utils.dart';

void main() {
  group('OuiPathSegment', () {
    test('static segment creation', () {
      final segment = OuiPathSegment.static('home');
      expect(segment.id, 'home');
      expect(segment.pattern, '^home\$');
      expect(segment.isParametric, false);
    });

    test('argument segment creation with pattern', () {
      final segment = OuiPathSegment.argument('id', pattern: r'\d+');
      expect(segment.id, 'id');
      expect(segment.pattern, r'\d+');
      expect(segment.isParametric, true);
    });

    test('argument segment creation without pattern', () {
      final segment = OuiPathSegment.argument('name');
      expect(segment.id, 'name');
      expect(segment.pattern, null);
      expect(segment.isParametric, true);
    });

    test('match parametric segment with complex patterns', () {
      final testCases = [
        (
          pattern: r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', // Email
          input: 'test@example.com',
          shouldMatch: true
        ),
        (
          pattern: r'[!@#$%^&*(),.?":{}|<>]', // Special characters
          input: '@#\$',
          shouldMatch: true
        ),
      ];

      for (final testCase in testCases) {
        final segment =
            OuiPathSegment.argument('param', pattern: testCase.pattern);
        final path = OuiPath([segment]);
        final match = path.match([testCase.input], []);

        expect(
          match.segments.isNotEmpty,
          testCase.shouldMatch,
          reason:
              'Failed for pattern: ${testCase.pattern} with input: ${testCase.input}',
        );
      }
    });

    test('toString method', () {
      final segment = OuiPathSegment.static('home');
      expect(
        segment.toString(),
        'OuiPathSegment(id: home, pattern: ^home\$, isParametric: false)',
      );
    });

    test('invalid regex in argument segment', () {
      expect(
        () => OuiPathSegment.argument('id', pattern: r'['),
        throwsA(isA<FormatException>()),
      );
    });

    test('static segment with empty string', () {
      expect(
        () => OuiPathSegment.static(''),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('OuiPath', () {
    test('empty path', () {
      const path = OuiPath([]);
      expect(path.isEmpty, true);
      expect(path.length, 0);
    });

    test('non-empty path', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      expect(path.isEmpty, false);
      expect(path.length, 1);
    });

    test('match static segment', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      final match = path.match(['home'], []);
      expect(match.segments.length, 1);
      expect(match.segments[0].original, 'home');
    });

    test('match parametric segment with pattern', () {
      final segment = OuiPathSegment.argument('id', pattern: r'\d+');
      final path = OuiPath([segment]);
      final match = path.match(['123'], []);
      expect(match.segments.length, 1);
      expect(match.segments[0].original, '123');
      expect(match.segments[0].content, '123');
    });

    test('match parametric segment without pattern', () {
      final segment = OuiPathSegment.argument('name');
      final path = OuiPath([segment]);
      final match = path.match(['john'], []);
      expect(match.segments.length, 1);
      expect(match.segments[0].original, 'john');
      expect(match.segments[0].content, 'john');
    });

    test('match multiple static segments', () {
      final segment1 = OuiPathSegment.static('home');
      final segment2 = OuiPathSegment.static('about');
      final path = OuiPath([segment1, segment2]);
      final match = path.match(['home', 'about'], []);
      expect(match.segments.length, 2);
      expect(match.segments[0].original, 'home');
      expect(match.segments[1].original, 'about');
    });

    test('match mixed static and parametric segments', () {
      final segment1 = OuiPathSegment.static('home');
      final segment2 = OuiPathSegment.argument('id', pattern: r'\d+');
      final path = OuiPath([segment1, segment2]);
      final match = path.match(['home', '123'], []);
      expect(match.segments.length, 2);
      expect(match.segments[0].original, 'home');
      expect(match.segments[1].original, '123');
      expect(match.segments[1].content, '123');
    });

    test('no match for parametric segment with incorrect pattern', () {
      final segment = OuiPathSegment.argument('id', pattern: r'\d+');
      final path = OuiPath([segment]);
      final match = path.match(['abc'], []);
      expect(match.segments.length, 0);
    });

    test('match with leftover segments', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      final match = path.match(['home', 'extra'], []);
      expect(match.segments.length, 1);
      expect(match.segments[0].original, 'home');
      expect(match.leftovers.length, 1);
      expect(match.leftovers[0], 'extra');
    });

    test('no match for static segment', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      final match = path.match(['about'], []);
      expect(match.segments.length, 0);
    });

    test('add segments to path', () {
      final segment1 = OuiPathSegment.static('home');
      final segment2 = OuiPathSegment.argument('id');
      final path = OuiPath([segment1]);
      final newPath = path.add([segment2]);
      expect(newPath.segments.length, 2);
      expect(newPath.segments[1].id, 'id');
    });

    test('partial match with non-matching leftover', () {
      final segment1 = OuiPathSegment.static('home');
      final segment2 = OuiPathSegment.argument('id');
      final path = OuiPath([segment1, segment2]);
      final match = path.match(['home', '123', 'extra'], [testScreen('item')]);
      expect(match.segments.length, 2);
      expect(match.leftovers.length, 1);
      expect(match.leftovers[0], 'extra');
    });

    test('empty input path', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      final match = path.match([], [testScreen('home')]);
      expect(match.segments.length, 0);
      expect(match.leftovers.length, 0);
    });

    test('path longer than defined segments', () {
      final segment = OuiPathSegment.static('home');
      final path = OuiPath([segment]);
      final match = path.match(['home', 'extra', 'more'], [testScreen('home')]);
      expect(match.segments.length, 1);
      expect(match.leftovers.length, 2);
    });

    test('case sensitivity in static segment', () {
      final segment = OuiPathSegment.static('Home');
      final path = OuiPath([segment]);
      final match = path.match(['home'], [testScreen('Home')]);
      expect(match.segments.length, 0);
    });
  });
}
