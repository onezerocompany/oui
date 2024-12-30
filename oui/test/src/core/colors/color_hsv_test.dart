import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/colors/hsv_color.dart';

void main() {
  group('HsvColor', () {
    test('should create HSV color with valid inputs', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      expect(color.hue, 120);
      expect(color.saturation, 0.5);
      expect(color.value, 0.5);
    });

    test('should throw assertion error for invalid hue', () {
      expect(() => HsvColor.fromHSV(360), throwsAssertionError);
    });

    test('should convert RGB to HSV correctly', () {
      const rgbColor = Color.fromRGB(0.5, 0.5, 0.5);
      final hsvColor = HsvColor.fromColor(rgbColor);
      expect(hsvColor.hue, 0);
      expect(hsvColor.saturation, 0);
      expect(hsvColor.value, 0.5);
    });

    test('should rotate hue correctly', () {
      final color = HsvColor.fromHSV(350);
      final rotatedColor = color.rotateHue(20);
      expect(rotatedColor.hue, 10);
    });

    test('should saturate correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      final saturatedColor = color.saturate(0.3);
      expect(saturatedColor.saturation, 0.8);
    });

    test('should desaturate correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      final desaturatedColor = color.desaturate(0.3);
      expect(desaturatedColor.saturation, 0.2);
    });

    test('should lighten correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      final lightenedColor = color.lighten(0.3);
      expect(lightenedColor.value, 0.8);
    });

    test('should darken correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      final darkenedColor = color.darken(0.3);
      expect(darkenedColor.value, 0.2);
    });

    test('should interpolate correctly', () {
      final color1 = HsvColor.fromHSV(0, 1, 1);
      final color2 = HsvColor.fromHSV(120, 0.5, 0.5);
      final interpolatedColor = color1.lerpWith(color2, 0.5);
      expect(interpolatedColor.hue, 60);
      expect(interpolatedColor.saturation, 0.75);
      expect(interpolatedColor.value, 0.75);
    });
  });
}
