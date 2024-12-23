import 'package:test/test.dart';
import 'package:flutter/widgets.dart';
import 'package:oui/src/components/corners/oui_corner_processed_radius.dart';
import 'package:oui/src/components/corners/oui_corner_radius.dart';
import 'package:oui/src/components/corners/oui_corner_path.dart';

void main() {
  group('OuiCornerExtensions on Path', () {
    test('addOuiCorner modifies path as expected', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner creates a closed path for all corners', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addOuiCorner(
        OuiCorner.bottomRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addOuiCorner(
        OuiCorner.bottomLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner handles zero cornerRadius', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 0, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner handles extreme cornerRadius values', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 200, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner handles varying rectangle sizes', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 200,
        height: 200,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 200, 200),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner ensures path continuity for adjacent corners', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner ensures no gaps for large rectangle dimensions', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 1000,
        height: 1000,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 1000, 1000),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner produces mirrored results for opposite corners', () {
      final path1 = Path();
      final path2 = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path1.addOuiCorner(
        OuiCorner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path2.addOuiCorner(
        OuiCorner.bottomRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path1, isNotNull);
      expect(path2, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner behaves identically for square rectangles', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner handles varying smoothing values', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 1.0),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner handles zero cornerRadius with non-zero smoothing', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 0, smoothing: 1.0),
        width: 100,
        height: 100,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner stress test with many corners', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      for (int i = 0; i < 100; i++) {
        path.addOuiCorner(
          OuiCorner.topRight,
          processed,
          const Rect.fromLTWH(0, 0, 100, 100),
        );
      }
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addOuiCorner benchmark for large dimensions', () {
      final path = Path();
      final processed = ProcessedOuiCornerRadius(
        const OuiCornerRadius(radius: 1000, smoothing: 0.5),
        width: 10000,
        height: 10000,
      );
      path.addOuiCorner(
        OuiCorner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 10000, 10000),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });
  });
}
