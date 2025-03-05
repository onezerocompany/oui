import 'package:flutter/src/widgets/framework.dart';
import 'package:oui/oui.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  group('ScreenRegistry', () {
    test('Constructor initializes with roots', () {
      final roots = [
        MockScreen(name: 'root1'),
        MockScreen(name: 'root2'),
      ];

      final registry = ScreenRegistry(roots);

      expect(registry.roots, equals(roots));
    });

    test('fromConfig factory creates registry from config', () {
      final roots = [
        MockScreen(name: 'root1'),
        MockScreen(name: 'root2'),
      ];

      final config = Config(
        details: const AppDetails(
          id: "test",
          name: {Locale.any: "test"},
          version: Version(0, 0, 1),
        ),
        registry: ScreenRegistryConfig(screens: roots),
      );

      final registry = ScreenRegistry.fromConfig(config);

      expect(registry.roots, equals(roots));
    });

    group('_findScreens', () {
      late ScreenRegistry registry;
      late MockScreen root1, root2, child1, grandchild1, child2;

      setUp(() {
        grandchild1 = MockScreen(name: 'grandchild1');
        child1 = MockScreen(name: 'child1', childScreens: [grandchild1]);
        child2 = MockScreen(name: 'child2');
        root1 = MockScreen(name: 'root1', childScreens: [child1]);
        root2 = MockScreen(name: 'root2', childScreens: [child2]);

        registry = ScreenRegistry([root1, root2]);
      });

      test('finds screen at root level', () {
        final result = registry.resolve(context, screen: root1);
        expect(result.screens, [root1]);
      });

      test('finds child screen', () {
        final result = registry.resolve(context, screen: child1);
        expect(result.screens, [root1, child1]);
      });

      test('finds grandchild screen', () {
        final result = registry.resolve(context, screen: grandchild1);
        expect(result.screens, [root1, child1, grandchild1]);
      });

      test('throws error for screen not in registry', () {
        final unknownScreen = MockScreen(name: 'unknown');

        expect(
          () => registry.resolve(context, screen: unknownScreen),
          throwsA(
            isA<FlutterError>().having(
              (e) => e.message,
              'message',
              contains('Screen not found in the registry'),
            ),
          ),
        );
      });
    });

    group('_matchForScreen', () {
      test('creates match with static segments', () {
        final root = MockScreen(
          name: 'root',
          pathSegments: [PathSegment.static('home')],
        );
        final registry = ScreenRegistry([root]);

        final match = registry.resolve(context, screen: root);

        expect(match.segments.length, 1);
        expect(match.segments[0].id, 'home');
        expect(match.segments[0].original, 'home');
        expect(match.segments[0].isArgument, false);
      });

      test('creates match with arguments', () {
        final root = MockScreen(
          name: 'root',
          pathSegments: [
            PathSegment.static('user'),
            PathSegment.argument('id', pattern: RegExp(r'\d+')),
          ],
        );
        final registry = ScreenRegistry([root]);

        final match = registry.resolve(
          context,
          screen: root,
          arguments: {'id': '123'},
        );

        expect(match.segments.length, 2);
        expect(match.segments[0].id, 'user');
        expect(match.segments[1].id, 'id');
        expect(match.segments[1].original, '123');
        expect(match.segments[1].isArgument, true);
      });

      test('creates match for nested screens with combined segments', () {
        final child = MockScreen(
          name: 'child',
          pathSegments: [PathSegment.static('details')],
        );
        final root = MockScreen(
          name: 'root',
          pathSegments: [PathSegment.static('user')],
          childScreens: [child],
        );
        final registry = ScreenRegistry([root]);

        final match = registry.resolve(context, screen: child);

        expect(match.segments.length, 2);
        expect(match.segments[0].id, 'user');
        expect(match.segments[1].id, 'details');
      });
    });

    group('resolve with URI', () {
      late ScreenRegistry registry;
      late MockScreen homeScreen, profileScreen, settingsScreen, userScreen;

      setUp(() {
        homeScreen = MockScreen(
          name: 'home',
          pathSegments: [PathSegment.static('home')],
        );

        userScreen = MockScreen(
          name: 'user',
          pathSegments: [
            PathSegment.static('users'),
            PathSegment.argument('id', pattern: RegExp(r'\d+')),
          ],
        );

        profileScreen = MockScreen(
          name: 'profile',
          pathSegments: [PathSegment.static('profile')],
        );

        settingsScreen = MockScreen(
          name: 'settings',
          pathSegments: [PathSegment.static('settings')],
        );

        registry = ScreenRegistry([
          homeScreen,
          userScreen,
          profileScreen,
          settingsScreen,
        ]);
      });

      test('resolves URI to correct screen', () {
        final match = registry.resolve(context, uri: Uri(path: '/home'));

        expect(match.screens, [homeScreen]);
        expect(match.matchRate, 1.0);
      });

      test('resolves URI with arguments', () {
        final match = registry.resolve(context, uri: Uri(path: '/users/123'));

        expect(match.screens, [userScreen]);
        expect(match.segments.length, 2);
        expect(match.segments[1].original, '123');
      });

      test('chooses best match when multiple partial matches exist', () {
        // Create a more specific user detail screen
        final userDetailScreen = MockScreen(
          name: 'userDetail',
          pathSegments: [
            PathSegment.static('users'),
            PathSegment.argument('id', pattern: RegExp(r'\d+')),
            PathSegment.static('detail'),
          ],
        );

        final registryWithDetail = ScreenRegistry([
          homeScreen,
          userScreen,
          userDetailScreen,
        ]);

        final match = registryWithDetail.resolve(
          context,
          uri: Uri(path: '/users/123/detail'),
        );

        expect(match.screens, [userDetailScreen]);
      });

      test('handles redirects', () {
        final redirectingScreen = MockScreen(
          name: 'redirecting',
          pathSegments: [PathSegment.static('redirect')],
          redirectUri: Uri(path: '/home'),
        );

        final registryWithRedirect = ScreenRegistry([
          homeScreen,
          redirectingScreen,
        ]);

        final match = registryWithRedirect.resolve(
          context,
          uri: Uri(path: '/redirect'),
        );

        // Should redirect to home
        expect(match.screens, [homeScreen]);
      });

      test('throws error for too many redirects', () {
        final redirectLoop1 = MockScreen(
          name: 'redirectLoop1',
          pathSegments: [PathSegment.static('loop1')],
          redirectUri: Uri(path: '/loop2'),
        );

        final redirectLoop2 = MockScreen(
          name: 'redirectLoop2',
          pathSegments: [PathSegment.static('loop2')],
          redirectUri: Uri(path: '/loop1'),
        );

        final registryWithLoop = ScreenRegistry([
          redirectLoop1,
          redirectLoop2,
        ]);

        expect(
          () => registryWithLoop.resolve(context, uri: Uri(path: '/loop1')),
          throwsA(
            isA<FlutterError>().having(
              (e) => e.message,
              'message',
              contains('Too many redirects'),
            ),
          ),
        );
      });

      test('throws error when no available roots', () {
        final unavailableScreen = MockScreen(
          name: 'unavailable',
          pathSegments: [PathSegment.static('unavailable')],
          shouldBeAvailable: false,
        );

        final registryWithUnavailableScreen =
            ScreenRegistry([unavailableScreen]);

        expect(
          () => registryWithUnavailableScreen.resolve(
            context,
            uri: Uri(path: '/unavailable'),
          ),
          throwsA(
            isA<FlutterError>().having(
              (e) => e.message,
              'message',
              contains('No available roots found'),
            ),
          ),
        );
      });

      test('returns first available root when no match found', () {
        final noMatchUri = Uri(path: '/nonexistent');
        final match = registry.resolve(context, uri: noMatchUri);

        // Should return the first available root
        expect(match.screens.length, 1);
        expect(match.screens[0], homeScreen);
      });
    });

    test('throws assertion error when neither uri nor screen is provided', () {
      final registry = ScreenRegistry([MockScreen(name: 'root')]);

      expect(
        () => registry.resolve(context),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when both uri and screen are provided', () {
      final root = MockScreen(name: 'root');
      final registry = ScreenRegistry([root]);

      expect(
        () => registry.resolve(context, uri: Uri(path: '/'), screen: root),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
