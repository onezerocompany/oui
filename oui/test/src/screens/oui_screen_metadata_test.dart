import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiScreenMetadata', () {
    test('should create an instance with required parameters', () {
      final pathSegments = [
        OuiPathSegment.static('home'),
        OuiPathSegment.static('dashboard'),
      ];
      final metadata = OuiScreenMetadata(
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
        OuiPathSegment.static('home'),
        OuiPathSegment.static('settings'),
      ];
      final attributes = {'key': 'value'};
      final metadata = OuiScreenMetadata(
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
  });
}
