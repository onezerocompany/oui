import 'package:test/test.dart';
import 'package:oui/src/components/corners/oui_corner_processed_radius.dart';
import 'package:oui/src/components/corners/oui_corner_radius.dart';

void main() {
  group('ProcessedOuiCornerRadius Tests', () {
    test('Constructor clamps radius with min(width, height)/2', () {
      const radius = OuiCornerRadius(radius: 50, smoothing: 0.5);
      final processed = ProcessedOuiCornerRadius(radius, width: 80, height: 60);
      expect(processed.cornerRadius, lessThanOrEqualTo(30));
    });

    test('Equality check', () {
      const r1 = OuiCornerRadius(radius: 10, smoothing: 0.5);
      final p1 = ProcessedOuiCornerRadius(r1, width: 100, height: 100);
      final p2 = ProcessedOuiCornerRadius(r1, width: 100, height: 100);
      expect(p1, p2);
    });
  });
}
