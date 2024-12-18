import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';
import '../screens/screen_testing_utils.dart';

void main() {
  group('OuiPathMatch', () {
    test('rawSegments returns original segments', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      expect(pathMatch.rawSegments, ['123']);
    });

    test('canPop returns true if screens are not empty', () {
      final pathMatch = OuiPathMatch([testScreen('test')], [], [], 1);

      expect(pathMatch.canPop, true);
    });

    test('canPop returns false if screens are empty', () {
      const pathMatch = OuiPathMatch([], [], [], 1);

      expect(pathMatch.canPop, false);
    });

    test('uri constructs Uri from raw segments', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      expect(pathMatch.uri.pathSegments, ['123']);
    });

    test('count returns the number of segments', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      expect(pathMatch.count, 1);
    });

    test('rate calculation with various segment counts', () {
      final testCases = [
        (matched: 1, expected: 2, rate: 0.5),
        (matched: 2, expected: 1, rate: 2.0),
        (matched: 0, expected: 1, rate: 0.0),
        // Add more cases
      ];

      for (final testCase in testCases) {
        final segment = OuiPathSegment.argument('userId');
        final matches = List.filled(
          testCase.matched,
          OuiPathSegmentMatch(segment: segment, original: '123'),
        );
        final pathMatch = OuiPathMatch(
          List.filled(testCase.matched, testScreen('test')),
          matches,
          [],
          testCase.expected,
        );

        expect(
          pathMatch.rate,
          testCase.rate,
          reason:
              'Failed for ${testCase.matched} matches and ${testCase.expected} expected',
        );
      }
    });

    test('rate returns the correct percentage of segments that matched', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 2);

      expect(pathMatch.rate, 0.5);
    });

    test('rate returns 0 if expectedSegmentCount is 0', () {
      const pathMatch = OuiPathMatch([], [], [], 0);

      expect(pathMatch.rate, 0);
    });

    test('pop removes the last count segments from the match', () {
      final segment1 = OuiPathSegment.argument('userId1');
      final match1 = OuiPathSegmentMatch(segment: segment1, original: '123');
      final segment2 = OuiPathSegment.argument('userId2');
      final match2 = OuiPathSegmentMatch(segment: segment2, original: '456');
      final pathMatch = OuiPathMatch(
        [testScreen('test1'), testScreen('test2')],
        [match1, match2],
        [],
        2,
      );

      final poppedMatch = pathMatch.pop(1);

      expect(poppedMatch.segments.length, 1);
      expect(poppedMatch.segments.first.original, '123');
      expect(poppedMatch.screens.length, 1);
    });

    test(
        'pop returns noMatch if count is greater than or equal to screens length',
        () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      final poppedMatch = pathMatch.pop(1);

      expect(poppedMatch, OuiPathMatch.noMatch);
    });

    test('pop with count 0 does not modify the match', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      final poppedMatch = pathMatch.pop(0);

      expect(poppedMatch.screens.length, 1);
      expect(poppedMatch.segments.length, 1);
    });

    test('pop with negative count behaves correctly', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      final poppedMatch = pathMatch.pop(-1);

      expect(poppedMatch, pathMatch); // Behavior choice: returns unchanged
    });

    test('uri returns empty path when there are no segments', () {
      const pathMatch = OuiPathMatch([], [], [], 1);

      expect(pathMatch.uri.pathSegments, isEmpty);
    });

    test('rate returns correct value when segments exceed expected count', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');
      final pathMatch = OuiPathMatch(
        [testScreen('test'), testScreen('extra')],
        [match, match],
        [],
        1,
      );

      expect(pathMatch.rate, 2.0); // Over 100% match
    });

    test('rawSegments handles empty or invalid segments', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '');
      final pathMatch = OuiPathMatch([testScreen('test')], [match], [], 1);

      expect(pathMatch.rawSegments, ['']);
    });

    test('OuiPathSegmentMatch.content uses _value if provided', () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(
        segment: segment,
        original: '123',
        value: 'user_123',
      );

      expect(match.content, 'user_123');
    });

    test('OuiPathSegmentMatch.content falls back to original if _value is null',
        () {
      final segment = OuiPathSegment.argument('userId');
      final match = OuiPathSegmentMatch(segment: segment, original: '123');

      expect(match.content, '123');
    });

    test('OuiPathMatch initializes with empty inputs', () {
      const pathMatch = OuiPathMatch([], [], [], 0);

      expect(pathMatch.screens, isEmpty);
      expect(pathMatch.segments, isEmpty);
      expect(pathMatch.leftovers, isEmpty);
      expect(pathMatch.count, 0);
    });
  });
}
