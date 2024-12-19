import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/screens/oui_screen_size.dart';

void main() {
  group('OuiScreenSizeDimension', () {
    test('default values', () {
      const dimension = OuiScreenSizeDimension();
      expect(dimension.minimum, 300);
      expect(dimension.maximum, 1400);
      expect(dimension.weight, 1);
    });

    test('custom values', () {
      const dimension =
          OuiScreenSizeDimension(minimum: 320, maximum: 1024, weight: 2);
      expect(dimension.minimum, 320);
      expect(dimension.maximum, 1024);
      expect(dimension.weight, 2);
    });

    test('contains method', () {
      const dimension = OuiScreenSizeDimension(minimum: 320, maximum: 1024);
      expect(dimension.contains(300), false);
      expect(dimension.contains(320), true);
      expect(dimension.contains(500), true);
      expect(dimension.contains(1024), true);
      expect(dimension.contains(1100), false);
    });
  });

  group('OuiScreenSize', () {
    test('default constructor', () {
      const screenSize = OuiScreenSize();
      expect(screenSize.width.minimum, 300);
      expect(screenSize.width.maximum, 1400);
      expect(screenSize.width.weight, 1);
      expect(screenSize.height.minimum, 300);
      expect(screenSize.height.maximum, 1400);
      expect(screenSize.height.weight, 1);
    });

    test('custom dimensions', () {
      const widthDimension =
          OuiScreenSizeDimension(minimum: 320, maximum: 1024, weight: 2);
      const heightDimension =
          OuiScreenSizeDimension(minimum: 480, maximum: 1920, weight: 3);
      const screenSize =
          OuiScreenSize(width: widthDimension, height: heightDimension);
      expect(screenSize.width.minimum, 320);
      expect(screenSize.width.maximum, 1024);
      expect(screenSize.width.weight, 2);
      expect(screenSize.height.minimum, 480);
      expect(screenSize.height.maximum, 1920);
      expect(screenSize.height.weight, 3);
    });
  });
}
