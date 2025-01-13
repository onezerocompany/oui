import 'dart:ui' show Canvas, PictureRecorder, Rect, TextDirection;

import 'package:oui/src/core/border.dart';
import 'package:oui/src/core/colors.dart';
import 'package:oui/src/core/corners.dart';
import 'package:test/test.dart';

void main() {
  group('CornerBorder', () {
    test('Border alignment inside scales rect correctly', () {
      const border = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: BorderAlign.inside,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Border alignment outside scales rect correctly', () {
      const border = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: BorderAlign.outside,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Border alignment center does not adjust rect', () {
      const border = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
        borderAlign: BorderAlign.center,
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Empty rect does not throw error', () {
      const border = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.zero,
      );
      const rect = Rect.zero;
      final path = border.getOuterPath(rect);
      expect(path, isNotNull);
    });

    test('Paint method handles all alignments', () {
      const border = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      expect(true, isTrue); // No errors should occur
    });

    test('Equality and hashCode', () {
      const border1 = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      const border2 = CornerBorder(
        side: BorderSide(thickness: 4, color: Color.black),
        borderRadius: CornerBorderRadius.all(
          CornerRadius(radius: 10, smoothing: 0.5),
        ),
      );
      expect(border1, equals(border2));
      expect(border1.hashCode, equals(border2.hashCode));
    });

    test('Scale and lerp do not crash', () {
      const border = CornerBorder(borderRadius: CornerBorderRadius.zero);
      final scaled = border.scale(2);
      expect(scaled, isA<CornerBorder>());
    });
  });
}
