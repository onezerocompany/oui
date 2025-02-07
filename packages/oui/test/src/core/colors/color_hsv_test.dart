import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors.dart';

void main() {
  group('HsvColor', () {
    test('should create HSV color with valid inputs', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      expect(color.hue, 120);
      expect(color.saturation, 0.5);
      expect(color.value, 0.5);
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
      final lightenedColor = color.lighten(0.3, mode: LightnessMode.value);
      expect(lightenedColor.value, 0.8);
    });

    test('should darken correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 0.5);
      final darkenedColor = color.darken(0.3, mode: LightnessMode.value);
      expect(darkenedColor.value, 0.2);
    });

    test('should interpolate correctly', () {
      final color1 = HsvColor.fromHSV(0, 1, 1);
      final color2 = HsvColor.fromHSV(120, 0.5, 0.5);
      final interpolatedColor = color1.lerpTo(color2, 0.5);
      expect(interpolatedColor.hue, 60);
      expect(interpolatedColor.saturation, 0.75);
      expect(interpolatedColor.value, 0.75);
    });

    test('should clamp hue correctly', () {
      final color = HsvColor.fromHSV(359, 0.5, 0.5);
      final clampedColor = color.clampingHue(0, 300);
      expect(clampedColor.hue, 300);
    });

    test('should clamp saturation correctly', () {
      final color = HsvColor.fromHSV(120, 1, 0.5);
      final clampedColor = color.clampingSaturation(0, 0.5);
      expect(clampedColor.saturation, 0.5);
    });

    test('should clamp value correctly', () {
      final color = HsvColor.fromHSV(120, 0.5, 1);
      final clampedColor = color.clampingLightness(0, 0.8);
      expect(clampedColor.value, 0.8);
    });

    test('should create HSV color from HSL color correctly', () {
      final hslColor = HslColor.fromHSL(120, 0.5, 0.5);
      final hsvColor = HsvColor.fromHSL(hslColor);
      expect(hsvColor.hue, 120);
      expect(hsvColor.saturation, closeTo(0.666666, 0.001));
      expect(hsvColor.value, 0.75);
    });

    test('should convert HSV to RGB correctly', () {
      final hsvColor = HsvColor.fromHSV(120, 0.5, 0.5);
      final rgbColor = hsvColor.color;
      expect(rgbColor.red, 0.25);
      expect(rgbColor.green, 0.5);
      expect(rgbColor.blue, 0.25);
    });

    test('should convert HSV to HSL correctly', () {
      final hsvColor = HsvColor.fromHSV(120, 0.5, 0.5);
      final hslColor = hsvColor.hsl;
      expect(hslColor.hue, 120);
      expect(hslColor.saturation, closeTo(0.33333333, 0.00001));
      expect(hslColor.lightness, 0.375);
    });
  });
}
