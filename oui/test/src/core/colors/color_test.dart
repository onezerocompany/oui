import 'dart:ui' as ui show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/colors/hsl_color.dart';
import 'package:oui/src/core/colors/hsv_color.dart';

void main() {
  group('Color', () {
    test('fromRGB constructor', () {
      const color = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      expect(color.red, 0.5);
      expect(color.green, 0.4);
      expect(color.blue, 0.3);
      expect(color.alpha, 0.8);
      expect(color.colorSpace, RgbColorSpace.sRGB);
    });

    test('fromHSV constructor', () {
      final hsv = HsvColor.fromHSV(0.5, 0.4, 0.3);
      final color = Color.fromHSV(hsv);
      expect(color, hsv.color);
    });

    test('fromHSL constructor', () {
      final hsl = HslColor.fromHSL(0.5, 0.4, 0.3);
      final color = Color.fromHSL(hsl);
      expect(color, hsl.color);
    });

    test('isOpaque getter', () {
      const color = Color.fromRGB(0.5, 0.4, 0.3, 1.0);
      expect(color.isOpaque, true);
    });

    test('isVisible getter', () {
      const color = Color.fromRGB(0.5, 0.4, 0.3, 0.5);
      expect(color.isVisible, true);
    });

    test('flutterColor getter', () {
      const color = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      final flutterColor = color.uiColor;
      expect(flutterColor.alpha, (0.8 * 255).round());
      expect(flutterColor.red, (0.5 * 255).round());
      expect(flutterColor.green, (0.4 * 255).round());
      expect(flutterColor.blue, (0.3 * 255).round());
    });

    test('OuiColorExtension', () {
      const flutterColor = ui.Color.fromARGB(204, 128, 102, 77);
      final ouiColor = flutterColor.ouiColor;
      expect(ouiColor.red, 128 / 255);
      expect(ouiColor.green, 102 / 255);
      expect(ouiColor.blue, 77 / 255);
      expect(ouiColor.alpha, 204 / 255);
    });

    test('equality operator', () {
      const color1 = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      const color2 = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      const color3 = Color.fromRGB(0.5, 0.4, 0.3, 1.0);
      expect(color1 == color2, true);
      expect(color1 == color3, false);
    });

    test('hashCode', () {
      const color1 = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      const color2 = Color.fromRGB(0.5, 0.4, 0.3, 0.8);
      const color3 = Color.fromRGB(0.5, 0.4, 0.3, 1.0);
      expect(color1.hashCode == color2.hashCode, true);
      expect(color1.hashCode == color3.hashCode, false);
    });

    test('static constants', () {
      expect(Color.clear.red, 0);
      expect(Color.clear.green, 0);
      expect(Color.clear.blue, 0);
      expect(Color.clear.alpha, 0);

      expect(Color.black.red, 0);
      expect(Color.black.green, 0);
      expect(Color.black.blue, 0);
      expect(Color.black.alpha, 1);

      expect(Color.white.red, 1);
      expect(Color.white.green, 1);
      expect(Color.white.blue, 1);
      expect(Color.white.alpha, 1);
    });

    test('luminance (y) calculation', () {
      final List<(String, Color, double)> colors = [
        ("Black", Color.black, 0.0),
        ("White", Color.white, 1.0),
        ("Red", const Color.fromRGB(1.0, 0.0, 0.0), 0.2126),
        ("Green", const Color.fromRGB(0.0, 1.0, 0.0), 0.7152),
        ("Blue", const Color.fromRGB(0.0, 0.0, 1.0), 0.0722),
        ("Yellow", const Color.fromRGB(1.0, 1.0, 0.0), 0.9278),
        ("Cyan", const Color.fromRGB(0.0, 1.0, 1.0), 0.7874),
        ("Magenta", const Color.fromRGB(1.0, 0.0, 1.0), 0.2848),
        ("Gray (50%)", const Color.fromRGB(0.5, 0.5, 0.5), 0.2140411405),
        ("Dark Gray", const Color.fromRGB(0.2, 0.2, 0.2), 0.033104766570885055),
        ("Light Gray", const Color.fromRGB(0.8, 0.8, 0.8), 0.6038273389),
      ];

      for (final (name, color, luminance) in colors) {
        expect(color.y, closeTo(luminance, 0.00001), reason: name);
      }
    });

    test('contrastAgainst', () {
      final List<(Color, Color, double)> contrasts = [
        (Color.black, Color.white, 21),
        (Color.white, Color.black, 21),
        (Color.black, Color.black, 1),
        (Color.white, Color.white, 1),
        (Color.white, const Color.fromRGB(1.0, 0.0, 0.0), 4.0),
        (Color.white, const Color.fromRGB(0.0, 1.0, 0.0), 1.4),
        (Color.white, const Color.fromRGB(0.0, 0.0, 1.0), 8.59),
        (const Color.fromRGB(1, 0, 0), const Color.fromRGB(1, 1, 0), 3.72),
      ];

      for (final (color1, color2, contrast) in contrasts) {
        expect(color1.contrastAgainst(color2), closeTo(contrast, 0.1));
      }
    });
  });
}
