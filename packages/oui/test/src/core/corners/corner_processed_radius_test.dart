import 'package:oui/src/core/corners.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessedCornerRadius Tests', () {
    test('Constructor clamps radius with min(width, height)/2', () {
      const radius = CornerRadius(radius: 50, smoothing: 0.5);
      final processed = ProcessedCornerRadius(radius, width: 80, height: 60);
      expect(processed.cornerRadius, lessThanOrEqualTo(30));
    });

    test('Equality check', () {
      const r1 = CornerRadius(radius: 10, smoothing: 0.5);
      final p1 = ProcessedCornerRadius(r1, width: 100, height: 100);
      final p2 = ProcessedCornerRadius(r1, width: 100, height: 100);
      expect(p1, p2);
    });

    test('Inequality check', () {
      const r1 = CornerRadius(radius: 10, smoothing: 0.5);
      final p1 = ProcessedCornerRadius(r1, width: 100, height: 100);
      final p2 = ProcessedCornerRadius(r1, width: 80, height: 80);
      expect(p1, isNot(p2));
    });
  });
}
