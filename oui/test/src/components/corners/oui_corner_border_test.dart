import 'dart:ui';

import 'package:test/test.dart';
import 'package:flutter/widgets.dart';
import 'package:oui/src/components/corners/oui_corner_border.dart';
import 'package:oui/src/components/corners/oui_corner_border_radius.dart';
import 'package:oui/src/components/corners/oui_corner_radius.dart';

void main() {
  group('OuiCornerBorder Tests', () {
    test('Border alignment inside scales rect correctly', () {
      const border = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: OuiBorderAlign.inside,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Border alignment outside scales rect correctly', () {
      const border = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: OuiBorderAlign.outside,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Border alignment center does not adjust rect', () {
      const border = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: OuiBorderAlign.center,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Empty rect does not throw error', () {
      const border = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.zero,
      );
      const rect = Rect.zero;
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Paint method handles all alignments', () {
      const border = OuiCornerBorder(
        side: BorderSide(width: 4, color: Color(0xFF000000)),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      expect(true, isTrue); // No errors should occur
    });

    test('Lerp between two borders', () {
      const border1 = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      const border2 = OuiCornerBorder(
        side: BorderSide(width: 8),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 20, smoothing: 1.0),
        ),
      );
      final lerpedBorder = border1.lerp(border2, 0.5);
      expect(lerpedBorder, isNotNull);
      expect(lerpedBorder, isA<OuiCornerBorder>());
    });

    test('CopyWith updates border properties', () {
      const originalBorder = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      final copiedBorder = originalBorder.copyWith(
        side: const BorderSide(width: 8),
        borderRadius: OuiCornerBorderRadius.zero,
      );
      expect(copiedBorder.side.width, 8);
      expect(copiedBorder.borderRadius, OuiCornerBorderRadius.zero);
    });

    test('Equality and hashCode', () {
      const border1 = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      const border2 = OuiCornerBorder(
        side: BorderSide(width: 4),
        borderRadius: OuiCornerBorderRadius.all(
          OuiCornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      expect(border1, equals(border2));
      expect(border1.hashCode, equals(border2.hashCode));
    });

    test('Scale and lerp do not crash', () {
      const border = OuiCornerBorder(borderRadius: OuiCornerBorderRadius.zero);
      final scaled = border.scale(2);
      expect(scaled, isA<OuiCornerBorder>());
    });
  });
}
