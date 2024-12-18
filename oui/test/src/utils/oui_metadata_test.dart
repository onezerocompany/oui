import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiMetadata', () {
    test('should create an instance with required name', () {
      var metadata = OuiMetadata(name: 'Test Component');
      expect(metadata.name, 'Test Component');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, isEmpty);
    });

    test('should create an instance with all parameters', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      const attributes = {'key1': 'value1', 'key2': 'value2'};
      var metadata = OuiMetadata(
        name: 'Test Component',
        icon: iconData,
        attributes: attributes,
      );
      expect(metadata.name, 'Test Component');
      expect(metadata.icon, iconData);
      expect(metadata.attributes, attributes);
    });

    test('should handle null icon and empty attributes', () {
      var metadata = OuiMetadata(name: 'Test Component');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, isEmpty);
    });

    test('should throw on invalid name', () {
      expect(
        () => OuiMetadata(name: ''),
        throwsAssertionError,
      );
    });

    test('should handle attribute manipulation', () {
      var metadata = OuiMetadata(
        name: 'Test',
        attributes: {'key': 'value'},
      );

      final updated = metadata.copyWith(
        attributes: {...metadata.attributes, 'newKey': 'newValue'},
      );

      expect(updated.attributes['newKey'], 'newValue');
      expect(metadata.attributes['newKey'], isNull);
    });

    test('should implement value equality', () {
      var metadata1 = OuiMetadata(name: 'Test');
      var metadata2 = OuiMetadata(name: 'Test');
      var metadata3 = OuiMetadata(name: 'Different');

      expect(metadata1, equals(metadata2));
      expect(metadata1, isNot(equals(metadata3)));
    });
  });
}
