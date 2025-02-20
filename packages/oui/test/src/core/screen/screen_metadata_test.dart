import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/screen.dart';
import 'package:oui/src/core/locales.dart' show Locale;
import 'package:oui/src/core/localization.dart';
import 'package:oui/src/core/routing.dart';

void main() {
  group('ScreenMetadata', () {
    test('should create an instance with required parameters', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('dashboard'),
      ]);

      final metadata = ScreenMetadata(
        path: {Locale.en: path},
        name: {Locale.en: 'Dashboard'},
      );

      expect(metadata.path.forLocale(null), path);
      expect(metadata.name.forLocale(null), 'Dashboard');
      expect(metadata.icon.forLocale(null), isNull);
      expect(metadata.attributes.forLocale(null), {});
    });

    test('should create an instance with all parameters', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('settings'),
      ]);
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: {Locale.any: path},
        name: {Locale.any: 'Settings'},
        icon: {Locale.any: Icons.abc},
        attributes: {Locale.any: attributes},
      );

      expect(metadata.path.forLocale(null), path);
      expect(metadata.name.forLocale(null), 'Settings');
      expect(metadata.icon.forLocale(null), Icons.abc);
      expect(metadata.attributes.forLocale(null), attributes);
    });

    test('should create an instance with empty attributes', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('profile'),
      ]);

      final metadata = ScreenMetadata(
        path: {Locale.any: path},
        name: {Locale.any: 'Profile'},
      );

      expect(metadata.path.forLocale(null), path);
      expect(metadata.name.forLocale(null), 'Profile');
      expect(metadata.icon.forLocale(null), isNull);
      expect(metadata.attributes.forLocale(null), {});
    });

    test('should create an instance with null icon', () {
      final path = Path([
        PathSegment.static('home'),
        PathSegment.static('notifications'),
      ]);
      final attributes = {'key': 'value'};
      final metadata = ScreenMetadata(
        path: {Locale.any: path},
        name: {Locale.any: 'Notifications'},
        icon: {Locale.any: null},
        attributes: {Locale.any: attributes},
      );

      expect(metadata.path.forLocale(null), path);
      expect(metadata.name.forLocale(null), 'Notifications');
      expect(metadata.icon.forLocale(null), isNull);
      expect(metadata.attributes.forLocale(null), attributes);
    });
  });
}
