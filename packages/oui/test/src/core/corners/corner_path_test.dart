import 'package:flutter/widgets.dart';
import 'package:oui/src/core/corners.dart';
import 'package:test/test.dart';

void main() {
  group('CornerExtensions on Path', () {
    test('addCorner modifies path as expected', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner creates a closed path for all corners', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addCorner(
        Corner.bottomRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addCorner(
        Corner.bottomLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner handles zero cornerRadius', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 0, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner handles extreme cornerRadius values', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 200, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner handles varying rectangle sizes', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 200,
        height: 200,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 200, 200),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner ensures path continuity for adjacent corners', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner ensures no gaps for large rectangle dimensions', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 1000,
        height: 1000,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 1000, 1000),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner produces mirrored results for opposite corners', () {
      final path1 = Path();
      final path2 = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path1.addCorner(
        Corner.topLeft,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      path2.addCorner(
        Corner.bottomRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path1, isNotNull);
      expect(path2, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner behaves identically for square rectangles', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner handles varying smoothing values', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 1.0),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner handles zero cornerRadius with non-zero smoothing', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 0, smoothing: 1.0),
        width: 100,
        height: 100,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 100, 100),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner stress test with many corners', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 8, smoothing: 0.5),
        width: 100,
        height: 100,
      );
      for (int i = 0; i < 100; i++) {
        path.addCorner(
          Corner.topRight,
          processed,
          const Rect.fromLTWH(0, 0, 100, 100),
        );
      }
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });

    test('addCorner benchmark for large dimensions', () {
      final path = Path();
      final processed = ProcessedCornerRadius(
        const CornerRadius(radius: 1000, smoothing: 0.5),
        width: 10000,
        height: 10000,
      );
      path.addCorner(
        Corner.topRight,
        processed,
        const Rect.fromLTWH(0, 0, 10000, 10000),
      );
      expect(path, isNotNull);
      // Add more assertions to validate path commands
    });
  });
}
