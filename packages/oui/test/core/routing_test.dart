import 'package:oui/src/core/routing.dart'
    show PathSegment, PathSegmentMatch, Path, PathMatch;
import 'package:test/test.dart';

import 'mocks.dart' show MockScreen;

void main() {
  group('Routing', () {
    group('PathSegment', () {
      test('Initializing a static segment', () {
        final segment = PathSegment.static('foo');
        expect(segment.id, 'foo');
        expect(segment.pattern, null);
      });

      test('Initializing a wildcard dynamic segment', () {
        final segment = PathSegment.argument('foo');
        expect(segment.id, 'foo');
        expect(segment.pattern, RegExp(r'.*'));
      });

      test('Initializing a dynamic segment with a pattern', () {
        final pattern = RegExp(r'\d+');
        final segment = PathSegment.argument('foo', pattern: pattern);
        expect(segment.id, 'foo');
        expect(segment.pattern, pattern);
      });

      test('Initializing a dynamic segment with an invalid pattern', () {
        expect(
          // Let's ignore the linter warning since we are testing it
          // ignore: valid_regexps
          () => PathSegment.argument('foo', pattern: RegExp(r'[')),
          throwsA(isA<FormatException>()),
        );
      });

      test('Creating a static segment with empty ID throws assertion error',
          () {
        expect(
          () => PathSegment.static(''),
          throwsA(isA<AssertionError>()),
        );
      });

      test('Creating a dynamic segment with empty ID throws assertion error',
          () {
        expect(
          () => PathSegment.argument(''),
          throwsA(isA<AssertionError>()),
        );
      });

      test(
          'Creating a dynamic segment with multiline pattern throws assertion error',
          () {
        expect(
          () => PathSegment.argument(
            'foo',
            pattern: RegExp(r'.*', multiLine: true),
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('toString returns correctly formatted string', () {
        final segment = PathSegment.static('foo');
        expect(segment.toString(), 'PathSegment(id: foo, pattern: null)');

        final pattern = RegExp(r'\d+');
        final segmentWithPattern =
            PathSegment.argument('bar', pattern: pattern);
        expect(
          segmentWithPattern.toString(),
          'PathSegment(id: bar, pattern: $pattern)',
        );
      });

      group('equality and hashCode', () {
        test('equal segments with same ID and pattern', () {
          final segment1 = PathSegment.static('foo');
          final segment2 = PathSegment.static('foo');
          expect(segment1, equals(segment2));
          expect(segment1.hashCode, equals(segment2.hashCode));

          final pattern = RegExp(r'\d+');
          final segment3 = PathSegment.argument('bar', pattern: pattern);
          final segment4 = PathSegment.argument('bar', pattern: RegExp(r'\d+'));
          expect(segment3, equals(segment4));
          expect(segment3.hashCode, equals(segment4.hashCode));
        });

        test('not equal segments with different ID', () {
          final segment1 = PathSegment.static('foo');
          final segment2 = PathSegment.static('bar');
          expect(segment1, isNot(equals(segment2)));
          expect(segment1.hashCode, isNot(equals(segment2.hashCode)));
        });

        test('not equal segments with different types', () {
          final segment1 = PathSegment.static('foo');
          final segment2 = PathSegment.argument('foo');
          expect(segment1, isNot(equals(segment2)));
        });

        test('not equal segments with different patterns', () {
          final segment1 = PathSegment.argument('foo', pattern: RegExp(r'\d+'));
          final segment2 = PathSegment.argument('foo', pattern: RegExp(r'\w+'));
          expect(segment1, isNot(equals(segment2)));
        });
      });

      group('match method', () {
        test('Static segment matches case-insensitive', () {
          final segment = PathSegment.static('Foo');
          final match = segment.match('foo');
          expect(match, isNotNull);
          expect(match!.id, equals(segment.id));
          expect(match.original, equals('foo'));
          expect(
            match.content,
            equals('foo'),
          );
        });

        test('Static segment does not match different value', () {
          final segment = PathSegment.static('foo');
          final match = segment.match('bar');
          expect(match, isNull);
        });

        test('Wildcard argument segment matches any value', () {
          final segment = PathSegment.argument('param');
          final match = segment.match('value123');
          expect(match, isNotNull);
          expect(match!.id, equals(segment.id));
          expect(match.original, equals('value123'));
          expect(match.content, equals('value123'));
        });

        test('Argument segment with pattern matches valid value', () {
          final segment = PathSegment.argument(
            'id',
            pattern: RegExp(r'\d+'),
          );
          final match = segment.match('123');
          expect(match, isNotNull);
          expect(match!.id, equals(segment.id));
          expect(match.original, equals('123'));
          expect(match.content, equals('123'));
        });

        test('Argument segment with pattern does not match invalid value', () {
          final segment = PathSegment.argument(
            'id',
            pattern: RegExp(r'\d+'),
          );
          final match = segment.match('abc');
          expect(match, isNull);
        });

        test('Argument segment with pattern with group returns group value',
            () {
          final segment = PathSegment.argument(
            'id',
            pattern: RegExp(r'id-(\d+)'),
          );
          final match = segment.match('id-456');
          expect(match, isNotNull);
          expect(match!.content, equals('456'));
        });
      });
    });

    group('PathSegmentMatch', () {
      test('Basic initialization', () {
        const match = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          isArgument: true,
        );
        expect(match.id, equals('param'));
        expect(match.original, equals('value123'));
        expect(match.content, equals('value123'));
        expect(match.isArgument, isTrue);

        const matchWithValue = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          value: 'transformed',
          isArgument: false,
        );
        expect(matchWithValue.id, equals('param'));
        expect(matchWithValue.original, equals('value123'));
        expect(matchWithValue.content, equals('transformed'));
        expect(matchWithValue.isArgument, isFalse);
      });

      test('toString returns correctly formatted string', () {
        const match = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          isArgument: true,
        );
        expect(
          match.toString(),
          'PathSegmentMatch(id: param, original: value123, value: value123)',
        );

        const matchWithValue = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          value: 'transformed',
          isArgument: true,
        );
        expect(
          matchWithValue.toString(),
          'PathSegmentMatch(id: param, original: value123, value: transformed)',
        );
      });

      test('content returns value if provided, otherwise original', () {
        const match = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          isArgument: true,
        );
        expect(match.content, equals('value123'));

        const matchWithValue = PathSegmentMatch(
          id: 'param',
          original: 'value123',
          value: 'transformed',
          isArgument: true,
        );
        expect(matchWithValue.content, equals('transformed'));
      });
    });

    group('Path', () {
      test('Empty path has no segments', () {
        expect(Path.empty.segments, isEmpty);
        expect(Path.empty.isEmpty, isTrue);
        expect(Path.empty.length, equals(0));
      });

      test('Path with segments has correct length', () {
        final path = Path([
          PathSegment.static('foo'),
          PathSegment.argument('bar'),
        ]);
        expect(path.segments.length, equals(2));
        expect(path.isEmpty, isFalse);
        expect(path.length, equals(2));
      });

      test('Path.fromString creates segments from string path', () {
        final path = Path.fromString('/foo/:bar');
        expect(path.segments.length, equals(2));
        expect(path.segments[0], equals(PathSegment.static('foo')));
        expect(path.segments[1].id, equals('bar'));
        expect(path.segments[1].pattern, isNotNull);
      });

      test('Path.fromString ignores empty segments', () {
        final path = Path.fromString('//foo///:bar//');
        expect(path.segments.length, equals(2));
        expect(path.segments[0], equals(PathSegment.static('foo')));
        expect(path.segments[1].id, equals('bar'));
      });

      test('match returns segments that match the path', () {
        final path = Path([
          PathSegment.static('foo'),
          PathSegment.argument('bar'),
        ]);
        final uri = Uri(path: '/foo/baz');
        final match = path.match(uri, []);

        expect(match.segments.length, equals(2));
        expect(match.segments[0].id, equals('foo'));
        expect(match.segments[0].original, equals('foo'));
        expect(match.segments[0].isArgument, isFalse);
        expect(match.segments[1].id, equals('bar'));
        expect(match.segments[1].original, equals('baz'));
        expect(match.segments[1].isArgument, isTrue);
        expect(match.matchRate, equals(1.0));
      });

      test('match stops on first non-match and reports partial match rate', () {
        final path = Path([
          PathSegment.static('foo'),
          PathSegment.static('bar'),
          PathSegment.static('baz'),
        ]);
        final uri = Uri(path: '/foo/qux/baz');
        final match = path.match(uri, []);

        expect(match.segments.length, equals(1));
        expect(match.segments[0].id, equals('foo'));
        expect(match.leftovers, equals(['qux', 'baz']));
        expect(match.matchRate, equals(1.0 / 3.0));
      });

      test('match handles shorter input path with partial match rate', () {
        final path = Path([
          PathSegment.static('foo'),
          PathSegment.static('bar'),
          PathSegment.static('baz'),
        ]);
        final uri = Uri(path: '/foo/bar');
        final match = path.match(uri, []);

        expect(match.segments.length, equals(2));
        expect(match.segments[0].id, equals('foo'));
        expect(match.segments[1].id, equals('bar'));
        expect(match.leftovers, isEmpty);
        expect(match.matchRate, equals(2.0 / 3.0));
      });
    });

    group('PathMatch', () {
      test('Basic initialization', () {
        const match = PathMatch(
          segments: [],
          leftovers: ['foo', 'bar'],
          matchRate: 0.5,
          screens: [],
        );

        expect(match.segments, isEmpty);
        expect(match.leftovers, equals(['foo', 'bar']));
        expect(match.matchRate, equals(0.5));
        expect(match.screens, isEmpty);
      });

      test('canPop is true when screens is not empty', () {
        final match = PathMatch(
          segments: [],
          leftovers: [],
          matchRate: 1.0,
          screens: [
            MockScreen(
              name: 'test',
            ),
          ],
        );

        expect(match.canPop, isTrue);
      });

      test('canPop is false when screens is empty', () {
        const match = PathMatch(
          segments: [],
          leftovers: [],
          matchRate: 1.0,
          screens: [],
        );

        expect(match.canPop, isFalse);
      });

      test('uri returns constructed Uri from segments originals', () {
        const match = PathMatch(
          segments: [
            PathSegmentMatch(
              id: 'foo',
              original: 'bar',
              isArgument: false,
            ),
            PathSegmentMatch(
              id: 'baz',
              original: 'qux',
              isArgument: true,
            ),
          ],
          leftovers: [],
          matchRate: 1.0,
          screens: [],
        );

        expect(match.uri.path, equals('/bar/qux'));
      });

      test('parameters returns map of argument segments', () {
        const match = PathMatch(
          segments: [
            PathSegmentMatch(
              id: 'static',
              original: 'home',
              isArgument: false,
            ),
            PathSegmentMatch(
              id: 'userId',
              original: '123',
              isArgument: true,
            ),
            PathSegmentMatch(
              id: 'section',
              original: 'profile',
              value: 'settings',
              isArgument: true,
            ),
          ],
          leftovers: [],
          matchRate: 1.0,
          screens: [],
        );

        expect(
          match.parameters,
          equals({
            'userId': '123',
            'section': 'settings',
          }),
        );
      });

      test('operator[] returns parameter value by key', () {
        const match = PathMatch(
          segments: [
            PathSegmentMatch(
              id: 'userId',
              original: '123',
              isArgument: true,
            ),
          ],
          leftovers: [],
          matchRate: 1.0,
          screens: [],
        );

        expect(match['userId'], equals('123'));
        expect(match['unknown'], isNull);
      });

      test('toString returns correctly formatted string', () {
        const match = PathMatch(
          segments: [
            PathSegmentMatch(id: 'test', original: 'value', isArgument: true),
          ],
          leftovers: ['extra'],
          matchRate: 0.75,
          screens: [],
        );

        expect(
          match.toString(),
          contains(
            'PathMatch(segments: [PathSegmentMatch(id: test, original: value, value: value)], leftovers: [extra], matchRate: 0.75, screens: [])',
          ),
        );
      });
    });
  });
}
