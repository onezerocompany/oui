import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/locales.dart' show Locale;
import 'package:oui/src/core/localization.dart';
import 'package:oui/src/core/metadata.dart';

void main() {
  group('Metadata', () {
    test('should create an instance with required name', () {
      var metadata = const Metadata(name: {Locale.en: 'Test Component'});
      expect(metadata.name.forLocale(null), 'Test Component');
      expect(metadata.icon.forLocale(null), isNull);
      expect(metadata.attributes.forLocale(null), isEmpty);
    });

    test('should create an instance with all parameters', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      const attributes = {'key1': 'value1', 'key2': 'value2'};
      var metadata = const Metadata(
        name: {Locale.en: 'Test Component'},
        icon: {Locale.en: iconData},
        attributes: {Locale.en: attributes},
      );
      expect(metadata.name.forLocale(null), 'Test Component');
      expect(metadata.icon.forLocale(null), iconData);
      expect(metadata.attributes.forLocale(null), attributes);
    });

    test('should handle null icon and empty attributes', () {
      var metadata = const Metadata(
        name: {
          Locale.en: 'Test',
        },
      );
      expect(metadata.icon.forLocale(null), isNull);
      expect(metadata.attributes.forLocale(null), isEmpty);
    });

    test('should handle attribute manipulation', () {
      var metadata = const Metadata(
        name: {Locale.en: 'Test'},
        attributes: {
          Locale.en: {'key': 'value'},
        },
      );

      final updated = metadata.copyWith(
        attributes: {
          Locale.en: {
            ...metadata.attributes.forLocale(null) ?? {},
            'newKey': 'newValue',
          },
        },
      );

      expect(updated.attributes.forLocale(null)?['newKey'], 'newValue');
      expect(metadata.attributes.forLocale(null)?['newKey'], isNull);
    });

    test('should handle copyWith with null icon', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      var metadata = const Metadata(
        name: {Locale.en: 'Test'},
        icon: {Locale.en: iconData},
      );

      final updated = metadata.copyWith(icon: {Locale.en: null});
      expect(updated.icon.forLocale(null), isNull);
      expect(metadata.icon.forLocale(null), equals(iconData));
    });

    test('should implement value equality', () {
      var metadata1 = const Metadata(name: {Locale.en: 'Test'});
      var metadata2 = const Metadata(name: {Locale.en: 'Test'});
      var metadata3 = const Metadata(name: {Locale.en: 'Different'});

      expect(metadata1, equals(metadata2));
      expect(metadata1, isNot(equals(metadata3)));
    });
  });
}
