import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/localization.dart';
import 'package:oui/src/core/routing.dart';
import 'package:oui/src/core/screen.dart';

void main() {
  group('ScreenMetadata', () {
    test('should create an instance with required parameters', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('dashboard'),
      ]);
      final metadata = ScreenMetadata(
        path: Localized.always(path),
        name: Localized.always('Dashboard'),
      );

      expect(metadata.path.base, path);
      expect(metadata.name.base, 'Dashboard');
      expect(metadata.icon.base, isNull);
      expect(metadata.attributes.base, {});
    });

    test('should create an instance with all parameters', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('settings'),
      ]);
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: Localized.always(path),
        name: Localized.always('Settings'),
        icon: Localized.always(Icons.abc),
        attributes: Localized.always(attributes),
      );

      expect(metadata.path.base, path);
      expect(metadata.name.base, 'Settings');
      expect(metadata.icon.base, Icons.abc);
      expect(metadata.attributes.base, attributes);
    });

    test('should create an instance with empty attributes', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('profile'),
      ]);
      final metadata = ScreenMetadata(
        path: Localized.always(path),
        name: Localized.always('Profile'),
      );

      expect(metadata.path.base, path);
      expect(metadata.name.base, 'Profile');
      expect(metadata.icon.base, isNull);
      expect(metadata.attributes.base, {});
    });

    test('should create an instance with null icon', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('notifications'),
      ]);
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: Localized.always(path),
        name: Localized.always('Notifications'),
        icon: Localized.always(null),
        attributes: Localized.always(attributes),
      );

      expect(metadata.path.base, path);
      expect(metadata.name.base, 'Notifications');
      expect(metadata.icon.base, isNull);
      expect(metadata.attributes.base, attributes);
    });
  });
}
