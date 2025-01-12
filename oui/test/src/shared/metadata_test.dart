import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/localization.dart';
import 'package:oui/src/core/metadata.dart';

void main() {
  group('Metadata', () {
    test('should create an instance with required name', () {
      var metadata = const Metadata(name: Localized('Test Component'));
      expect(metadata.name.base, 'Test Component');
      expect(metadata.icon.base, isNull);
      expect(metadata.attributes.base, isEmpty);
    });

    test('should create an instance with all parameters', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      const attributes = {'key1': 'value1', 'key2': 'value2'};
      var metadata = const Metadata(
        name: Localized('Test Component'),
        icon: Localized(iconData),
        attributes: LocalizedMap(attributes),
      );
      expect(metadata.name.base, 'Test Component');
      expect(metadata.icon.base, iconData);
      expect(metadata.attributes.base, attributes);
    });

    test('should handle null icon and empty attributes', () {
      var metadata = const Metadata(name: Localized('Test Component'));
      expect(metadata.icon.base, isNull);
      expect(metadata.attributes.base, isEmpty);
    });

    test('should handle attribute manipulation', () {
      var metadata = const Metadata(
        name: Localized('Test'),
        attributes: LocalizedMap({'key': 'value'}),
      );

      final updated = metadata.copyWith(
        attributes:
            LocalizedMap({...metadata.attributes.base, 'newKey': 'newValue'}),
      );

      expect(updated.attributes.base['newKey'], 'newValue');
      expect(metadata.attributes.base['newKey'], isNull);
    });

    test('should handle copyWith with null icon', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      var metadata = const Metadata(
        name: Localized('Test'),
        icon: Localized(iconData),
      );

      final updated = metadata.copyWith(icon: const Localized(null));
      expect(updated.icon.base, isNull);
      expect(metadata.icon.base, equals(iconData));
    });

    test('should implement value equality', () {
      var metadata1 = const Metadata(name: Localized('Test'));
      var metadata2 = const Metadata(name: Localized('Test'));
      var metadata3 = const Metadata(name: Localized('Different'));

      expect(metadata1, equals(metadata2));
      expect(metadata1, isNot(equals(metadata3)));
    });
  });
}
