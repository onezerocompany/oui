import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/metadata/screen_metadata.dart';
import 'package:oui/src/core/router/path.dart';

void main() {
  group('ScreenMetadata', () {
    test('should create an instance with required parameters', () {
      final pathSegments = [
        PathSegment.static('home'),
        PathSegment.static('dashboard'),
      ];
      final metadata = ScreenMetadata(
        path: pathSegments,
        name: 'Dashboard',
      );

      expect(metadata.path, pathSegments);
      expect(metadata.name, 'Dashboard');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, {});
    });

    test('should create an instance with all parameters', () {
      final pathSegments = [
        PathSegment.static('home'),
        PathSegment.static('settings'),
      ];
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: pathSegments,
        name: 'Settings',
        icon: Icons.abc,
        attributes: attributes,
      );

      expect(metadata.path, pathSegments);
      expect(metadata.name, 'Settings');
      expect(metadata.icon, Icons.abc);
      expect(metadata.attributes, attributes);
    });

    test('should create an instance with empty attributes', () {
      final pathSegments = [
        PathSegment.static('home'),
        PathSegment.static('profile'),
      ];
      final metadata = ScreenMetadata(
        path: pathSegments,
        name: 'Profile',
      );

      expect(metadata.path, pathSegments);
      expect(metadata.name, 'Profile');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, {});
    });

    test('should create an instance with null icon', () {
      final pathSegments = [
        PathSegment.static('home'),
        PathSegment.static('notifications'),
      ];
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: pathSegments,
        name: 'Notifications',
        attributes: attributes,
      );

      expect(metadata.path, pathSegments);
      expect(metadata.name, 'Notifications');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, attributes);
    });
  });
}
