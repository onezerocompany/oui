import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/corners/oui_corner_radius.dart';

void main() {
  group('OuiCornerRadius', () {
    test('Validation for negative radius', () {
      expect(
        () => OuiCornerRadius(radius: -1, smoothing: 0.5),
        throwsAssertionError,
      );
    });

    test('Validation for negative smoothing', () {
      expect(
        () => OuiCornerRadius(radius: 1, smoothing: -0.5),
        throwsAssertionError,
      );
    });

    test('Validation for smoothing greater than 1', () {
      expect(
        () => OuiCornerRadius(radius: 1, smoothing: 1.5),
        throwsAssertionError,
      );
    });

    test('Validation for normal initialization', () {
      const radius = OuiCornerRadius(radius: 1, smoothing: 0.5);
      expect(radius.cornerRadius, 1);
      expect(radius.smoothing, 0.5);
    });

    test('Addition of two OuiCornerRadius objects', () {
      const radius1 = OuiCornerRadius(radius: 1, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 2, smoothing: 0.3);
      final result = radius1 + radius2 as OuiCornerRadius;
      expect(result.cornerRadius, 3);
      expect(result.smoothing, 0.4);
    });

    test('Subtraction of two OuiCornerRadius objects', () {
      const radius1 = OuiCornerRadius(radius: 3, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 1, smoothing: 0.3);
      final result = radius1 - radius2 as OuiCornerRadius;
      expect(result.cornerRadius, 2);
      expect(result.smoothing, 0.4);
    });

    test('Multiplication of a OuiCornerRadius by a scalar', () {
      const radius = OuiCornerRadius(radius: 2, smoothing: 0.5);
      final result = radius * 2;
      expect(result.cornerRadius, 4);
      expect(result.smoothing, 1.0);
    });

    test('Division of a OuiCornerRadius by a scalar', () {
      const radius = OuiCornerRadius(radius: 4, smoothing: 0.5);
      final result = radius / 2;
      expect(result.cornerRadius, 2);
      expect(result.smoothing, 0.25);
    });

    test('Integer division of a OuiCornerRadius by a scalar', () {
      const radius = OuiCornerRadius(radius: 5, smoothing: 0.5);
      final result = radius ~/ 2;
      expect(result.cornerRadius, 2.0);
      expect(result.smoothing, 0.0);
    });

    test('Modulus operation on a OuiCornerRadius', () {
      const radius = OuiCornerRadius(radius: 5, smoothing: 0.5);
      final result = radius % 2;
      expect(result.cornerRadius, 1);
      expect(result.smoothing, 0.5);
    });

    test('Linear interpolation (lerp) between two OuiCornerRadius objects', () {
      const radius1 = OuiCornerRadius(radius: 1, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 3, smoothing: 0.7);
      final result = OuiCornerRadius.lerp(radius1, radius2, 0.5);
      expect(result?.cornerRadius, 2);
      expect(result?.smoothing, 0.6);
    });

    test('Interpolation with null as one operand', () {
      const radius = OuiCornerRadius(radius: 2, smoothing: 0.5);
      final result = OuiCornerRadius.lerp(null, radius, 0.5);
      expect(result?.cornerRadius, 1);
      expect(result?.smoothing, 0.25);
    });

    test('Equality comparison between two identical objects', () {
      const radius1 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      expect(radius1 == radius2, true);
    });

    test('Inequality comparison between two different objects', () {
      const radius1 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 3, smoothing: 0.5);
      expect(radius1 != radius2, true);
    });

    test('Hash code consistency between equal objects', () {
      const radius1 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      const radius2 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      expect(radius1.hashCode, radius2.hashCode);
    });

    test('Validation of toString format', () {
      const radius = OuiCornerRadius(radius: 2, smoothing: 0.5);
      expect(
        radius.toString(),
        'OuiCornerRadius(cornerRadius: 2.00, smoothing: 0.50)',
      );
    });

    test('Operations with zero values (radius or smoothing)', () {
      const radius = OuiCornerRadius(radius: 0, smoothing: 0);
      final result = radius * 2;
      expect(result.cornerRadius, 0);
      expect(result.smoothing, 0);
    });

    test(
        'Interactions with the base Radius class (e.g., mixed-type operations)',
        () {
      const radius1 = OuiCornerRadius(radius: 2, smoothing: 0.5);
      const radius2 = Radius.circular(1);
      final result = radius1 + radius2;
      expect(result.x, 3);
      expect(result.y, 3);
      expect((result as OuiCornerRadius).smoothing, 0.5);
    });
  });
}
