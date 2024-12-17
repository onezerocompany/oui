import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

import 'screen_testing_utils.dart';

void main() {
  group('OuiScreenRegistryEntry', () {
    test('should create a registry entry with given screen and path', () {
      final screen = testScreen('home');
      final path = OuiPath([OuiPathSegment.static('home')]);
      final entry = OuiScreenRegistryEntry(screen, path);

      expect(entry.screen, screen);
      expect(entry.path, path);
      expect(entry.path.toString(), "home");
    });

    test('should match path segments correctly', () {
      final screen = testScreen('home');
      final path = OuiPath([OuiPathSegment.static('home')]);
      final entry = OuiScreenRegistryEntry(screen, path);

      final match = entry.match(['home']);
      expect(match, isNotNull);
      expect(match.screens.first, screen);
    });

    test('should not match incorrect path segments', () {
      final screen = testScreen('home');
      final path = OuiPath([OuiPathSegment.static('home')]);
      final entry = OuiScreenRegistryEntry(screen, path);

      final match = entry.match(['about']);
      expect(match.segments.length, 0);
    });

    test('should match dynamic path segments', () {
      final screen = testScreen('profile');
      final path = OuiPath([OuiPathSegment.argument('userId')]);
      final entry = OuiScreenRegistryEntry(screen, path);

      final match = entry.match(['123']);
      expect(match, isNotNull);
      expect(match.screens.first, screen);
    });
  });

  group('OuiScreenRegistry', () {
    group('Single-level tree', () {
      test('should handle single-level tree with one screen', () {
        final screen = testScreen('home');
        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match(['home']);
        expect(match.screens.first, screen);
      });
      test('should handle single-level dynamic tree with one screen', () {
        final screen = testScreen(
          'profile',
          segments: [OuiPathSegment.argument('userId')],
        );
        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match(['123']);
        expect(match.screens.first, screen);
      });
      test('should handle pattern matching', () {
        final screen = testScreen(
          'profile',
          segments: [OuiPathSegment.argument('userId', pattern: r'\d+')],
        );
        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match(['123']);
        expect(match.screens.first, screen);
      });
    });

    group('Multi-level nested screens', () {
      late OuiScreenRegistry registry;

      setUp(() {
        registry = OuiScreenRegistry(
          testScreen(
            'root',
            children: [
              testScreen(
                'static',
                children: [
                  testScreen('child1'),
                  testScreen('child2'),
                ],
              ),
              testScreen(
                'dynamic',
                segments: [
                  OuiPathSegment.argument('id', pattern: r'\d+'),
                ],
                children: [
                  testScreen('child3'),
                  testScreen(
                    'child4',
                    segments: [OuiPathSegment.argument('child4')],
                  ),
                ],
              ),
            ],
          ),
          null,
        );
      });

      test('should handle paths that are longer with non existing children',
          () {
        final match = registry.match(['root', 'static', 'child1', 'child2']);
        expect(match.leftovers, ['child2']);
        expect(match.screens.length, 3);
        expect(match.screens[0].id, 'root');
        expect(match.screens[1].id, 'static');
        expect(match.screens[2].id, 'child1');
      });

      test('should handle multi-level nested screens', () {
        final match = registry.match(['root', 'static', 'child1']);
        expect(match.screens.length, 3);
        expect(match.screens[0].id, 'root');
        expect(match.screens[1].id, 'static');
        expect(match.screens[2].id, 'child1');
      });

      test('should match overlapping paths correctly', () {
        final aboutTeam = testScreen('aboutTeam');
        final about = testScreen('about', children: [aboutTeam]);
        final root = testScreen('root', children: [about]);

        final registry = OuiScreenRegistry(root, null);

        final match = registry.match(['root', 'about']);
        expect(match.screens.length, 2);
        expect(match.screens[0], root);
        expect(match.screens[1], about);

        final deeperMatch = registry.match(['root', 'about', 'team']);
        expect(deeperMatch.screens.length, 3);
        expect(deeperMatch.screens[1], about);
        expect(deeperMatch.screens[2], aboutTeam);
      });
    });

    group('Dynamic and wildcard segments', () {
      test('should match screens with dynamic segments', () {
        final userProfile = testScreen(
          'userProfile',
          segments: [
            OuiPathSegment.argument('userId', pattern: r'\d+'),
          ],
        );
        final root = testScreen('users', children: [userProfile]);

        final registry = OuiScreenRegistry(root, null);

        final match = registry.match(['users', '42']);
        expect(match.screens.length, 2);
        expect(match.screens[1], userProfile);
      });

      test('should handle parametric path segments without a pattern', () {
        final screen = testScreen(
          'screen1',
          segments: [OuiPathSegment.argument('id')],
        );

        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match(['123']);
        expect(match.screens.first.id, 'screen1');
        expect(match.segments.first.content, '123');
      });

      test('should handle nested screens with mixed path segments', () {
        final childScreen = testScreen(
          'child1',
          segments: [OuiPathSegment.argument('childId', pattern: r'\d+')],
        );

        final parentScreen = testScreen(
          'parent1',
          segments: [OuiPathSegment.static('parent')],
          children: [childScreen],
        );

        final registry = OuiScreenRegistry(parentScreen, null);

        final match = registry.match(['parent', '123']);
        expect(match.screens.length, 2);
        expect(match.screens[0].id, 'parent1');
        expect(match.screens[1].id, 'child1');
        expect(match.segments[1].content, '123');
      });

      test('should match nested dynamic segments with multiple patterns', () {
        final detailsScreen = testScreen(
          'details',
          segments: [OuiPathSegment.argument('infoKey', pattern: r'[a-z]+')],
        );

        final profileScreen = testScreen(
          'profile',
          segments: [OuiPathSegment.argument('userId', pattern: r'\d+')],
          children: [detailsScreen],
        );

        final usersScreen = testScreen(
          'users',
          segments: [OuiPathSegment.static('users')],
          children: [profileScreen],
        );

        final registry = OuiScreenRegistry(usersScreen, null);

        final match = registry.match(['users', '123', 'data']);
        expect(match.screens.length, 3);
        expect(match.screens[0].id, 'users');
        expect(match.screens[1].id, 'profile');
        expect(match.screens[2].id, 'details');
        expect(match.segments[1].content, '123');
        expect(match.segments[2].content, 'data');
      });
    });

    group('Edge cases', () {
      test('should handle empty path segments gracefully', () {
        final root = testScreen('root');
        final registry = OuiScreenRegistry(root, null);

        final match = registry.match([]);
        expect(match.screens.first, root);
      });

      test('should return root match for unmatched paths', () {
        final root = testScreen('root');
        final registry = OuiScreenRegistry(root, null);

        final match = registry.match(['unmatched', 'path']);
        expect(match.screens.first, root);
      });

      test('should handle identical paths gracefully', () {
        final duplicate1 = testScreen('duplicate');
        final duplicate2 = testScreen('duplicate');
        final root = testScreen('root', children: [duplicate1, duplicate2]);

        expect(
          () => OuiScreenRegistry(root, null),
          throwsException,
        );
      });

      test('should return root match for empty segments', () {
        final screen =
            testScreen('screen1', segments: [OuiPathSegment.static('home')]);

        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match([]);
        expect(match.screens.first.id, 'screen1');
      });

      test('should handle duplicate screen IDs', () {
        final screen = testScreen('duplicate');
        final root = testScreen('root', children: [screen, screen]);

        expect(() => OuiScreenRegistry(root, null), throwsException);
      });
    });

    group('Screen retrieval', () {
      test('should retrieve screen by ID', () {
        final screen = testScreen('screen1');
        final registry = OuiScreenRegistry(screen, null);

        final retrieved = registry.getScreenById('screen1');
        expect(retrieved, screen);
      });

      test('should create a registry with a single screen', () {
        final screen =
            testScreen('screen1', segments: [OuiPathSegment.static('home')]);

        final registry = OuiScreenRegistry(screen, null);

        expect(registry.count, 1);
        expect(registry.getScreenById('screen1'), screen);
      });

      test('should create a registry with nested screens', () {
        final childScreen =
            testScreen('child1', segments: [OuiPathSegment.static('child')]);

        final parentScreen = testScreen(
          'parent1',
          segments: [OuiPathSegment.static('parent')],
          children: [childScreen],
        );

        final registry = OuiScreenRegistry(parentScreen, null);

        expect(registry.count, 2);
        expect(registry.getScreenById('parent1'), parentScreen);
        expect(registry.getScreenById('child1'), childScreen);
      });

      test('should match path segments correctly', () {
        final screen =
            testScreen('screen1', segments: [OuiPathSegment.static('home')]);

        final registry = OuiScreenRegistry(screen, null);

        final match = registry.match(['home']);
        expect(match.screens.first.id, 'screen1');
      });
    });
  });
}
