import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/colors/hsl_color.dart';
import 'package:oui/src/core/colors/hsv_color.dart';

void main() {
  group('HslColor', () {
    test('should create HSL color with valid inputs', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      expect(color.hue, 120);
      expect(color.saturation, 0.5);
      expect(color.lightness, 0.5);
    });

    test('should throw assertion error for invalid hue', () {
      expect(() => HslColor.fromHSL(360, 0.5, 0.5), throwsAssertionError);
    });

    test('should throw assertion error for invalid saturation', () {
      expect(() => HslColor.fromHSL(120, 1.5, 0.5), throwsAssertionError);
    });

    test('should throw assertion error for invalid lightness', () {
      expect(() => HslColor.fromHSL(120, 0.5, 1.5), throwsAssertionError);
    });

    test('should convert RGB to HSL correctly', () {
      const rgbColor = Color.fromRGB(0.5, 0.5, 0.5);
      final hslColor = HslColor.fromColor(rgbColor);
      expect(hslColor.hue, 0);
      expect(hslColor.saturation, 0);
      expect(hslColor.lightness, 0.5);
    });

    test('should convert HSL to RGB and back to HSL correctly', () {
      final hslColor = HslColor.fromHSL(120, 0.5, 0.5);
      final rgbColor = hslColor.color;
      final newHslColor = HslColor.fromColor(rgbColor);
      expect(newHslColor.hue, hslColor.hue);
      expect(newHslColor.saturation, hslColor.saturation);
      expect(newHslColor.lightness, hslColor.lightness);
    });

    test('should convert HSV to HSL correctly', () {
      final hsvColor = HsvColor.fromHSV(120, 0.5, 0.5);
      final hslColor = HslColor.fromHSV(hsvColor);
      expect(hslColor.hue, 120);
      expect(hslColor.saturation, 0.3333333333333333);
      expect(hslColor.lightness, 0.375);
    });

    test('should convert HSL to HSV and back to HSL correctly', () {
      final hslColor = HslColor.fromHSL(120, 0.5, 0.5);
      final hsvColor = hslColor.hsv;
      final newHslColor = HslColor.fromHSV(hsvColor);
      expect(newHslColor.hue, hslColor.hue);
      expect(newHslColor.saturation, hslColor.saturation);
      expect(newHslColor.lightness, hslColor.lightness);
    });

    test('should rotate hue correctly', () {
      final color = HslColor.fromHSL(350);
      final rotatedColor = color.rotateHue(20);
      expect(rotatedColor.hue, 10);
    });

    test('should saturate correctly', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final saturatedColor = color.saturate(0.3);
      expect(saturatedColor.saturation, 0.8);
    });

    test('should desaturate correctly', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final desaturatedColor = color.desaturate(0.3);
      expect(desaturatedColor.saturation, 0.2);
    });

    test('should lighten correctly', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final lightenedColor = color.lighten(0.3);
      expect(lightenedColor.lightness, 0.8);
    });

    test('should darken correctly', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final darkenedColor = color.darken(0.3);
      expect(darkenedColor.lightness, 0.2);
    });

    test('should interpolate correctly', () {
      final color1 = HslColor.fromHSL(0, 1, 0.5);
      final color2 = HslColor.fromHSL(120, 0.5, 0.25);
      final interpolatedColor = color1.lerpTo(color2, 0.5);
      expect(interpolatedColor.hue, 60);
      expect(interpolatedColor.saturation, 0.75);
      expect(interpolatedColor.lightness, 0.375);
    });

    test('should copy with modified properties', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final copiedColor = color.copyWith(hue: 240, saturation: 0.7);
      expect(copiedColor.hue, 240);
      expect(copiedColor.saturation, 0.7);
      expect(copiedColor.lightness, 0.5);
    });

    test('should create a new color with modified lightness', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final newColor = color.withLightness(0.8);
      expect(newColor.hue, 120);
      expect(newColor.saturation, 0.5);
      expect(newColor.lightness, 0.8);
    });

    test('should create a new color with modified hue', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final newColor = color.withHue(240);
      expect(newColor.hue, 240);
      expect(newColor.saturation, 0.5);
      expect(newColor.lightness, 0.5);
    });

    test('should create a new color with modified saturation', () {
      final color = HslColor.fromHSL(120, 0.5, 0.5);
      final newColor = color.withSaturation(0.8);
      expect(newColor.hue, 120);
      expect(newColor.saturation, 0.8);
      expect(newColor.lightness, 0.5);
    });

    test('should create a new color with clamped lightness', () {
      final color = HslColor.fromHSL(120, 0.5, 0.1);
      final newColor = color.clampingLightness(0.2, 1.0);
      expect(newColor.lightness, 0.2);
    });

    test('should create a new color with clamped hue', () {
      final color = HslColor.fromHSL(359, 0.5, 0.5);
      final newColor = color.clampingHue(0, 330);
      expect(newColor.hue, 330);
    });

    test('should create a new color with clamped saturation', () {
      final color = HslColor.fromHSL(120, 0.1, 0.5);
      final newColor = color.clampingSaturation(0.2, 0.8);
      expect(newColor.saturation, 0.2);
    });
  });
}
