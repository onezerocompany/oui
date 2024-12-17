import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiMetadata', () {
    test('should create an instance with required name', () {
      const metadata = OuiMetadata(name: 'Test Component');
      expect(metadata.name, 'Test Component');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, isEmpty);
    });

    test('should create an instance with all parameters', () {
      const iconData = IconData(0xe900, fontFamily: 'MaterialIcons');
      const attributes = {'key1': 'value1', 'key2': 'value2'};
      const metadata = OuiMetadata(
        name: 'Test Component',
        icon: iconData,
        attributes: attributes,
      );
      expect(metadata.name, 'Test Component');
      expect(metadata.icon, iconData);
      expect(metadata.attributes, attributes);
    });

    test('should handle null icon and empty attributes', () {
      const metadata = OuiMetadata(name: 'Test Component');
      expect(metadata.icon, isNull);
      expect(metadata.attributes, isEmpty);
    });
  });
}
