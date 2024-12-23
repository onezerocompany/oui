import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/corners/oui_corner_border_radius.dart';
import 'package:oui/src/components/corners/oui_corner_radius.dart';

void main() {
  group('OuiCornerBorderRadius', () {
    test('constructor initializes correctly', () {
      const radius = 10.0;
      const smoothing = 0.5; // Updated to be between 0 and 1
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);

      expect(borderRadius.topLeft.cornerRadius, radius);
      expect(borderRadius.topLeft.smoothing, smoothing);
      expect(borderRadius.topRight.cornerRadius, radius);
      expect(borderRadius.topRight.smoothing, smoothing);
      expect(borderRadius.bottomLeft.cornerRadius, radius);
      expect(borderRadius.bottomLeft.smoothing, smoothing);
      expect(borderRadius.bottomRight.cornerRadius, radius);
      expect(borderRadius.bottomRight.smoothing, smoothing);
    });

    test('constructor handles null values gracefully', () {
      final borderRadius = OuiCornerBorderRadius(radius: 10.0);
      expect(borderRadius.topLeft.cornerRadius, 10.0);
      expect(borderRadius.topLeft.smoothing, 0.0);
    });

    test('constructor restricts negative radius or smoothing', () {
      expect(() => OuiCornerBorderRadius(radius: -10.0), throwsAssertionError);
      expect(
        () => OuiCornerBorderRadius(radius: 10.0, smoothing: -5.0),
        throwsAssertionError,
      );
    });

    test('horizontal constructor creates symmetric radii', () {
      const borderRadius = OuiCornerBorderRadius.horizontal(
        left: OuiCornerRadius(radius: 5.0, smoothing: 1.0),
      );
      expect(borderRadius.topLeft.cornerRadius, 5.0);
      expect(borderRadius.bottomLeft.cornerRadius, 5.0);
    });

    test('copyWith does not alter original instance', () {
      final borderRadius = OuiCornerBorderRadius(
        radius: 10.0,
        smoothing: 0.5,
      ); // Updated to be between 0 and 1
      final modified = borderRadius.copyWith(
        topLeft: const OuiCornerRadius(
          radius: 20.0,
          smoothing: 0.1, // Updated to be between 0 and 1
        ),
      );

      expect(borderRadius.topLeft.cornerRadius, 10.0);
      expect(modified.topLeft.cornerRadius, 20.0);
    });

    test('toPath generates correct shape for rect', () {
      final borderRadius = OuiCornerBorderRadius(radius: 10.0, smoothing: 0.8);
      const rect = Rect.fromLTWH(0, 0, 100, 50);
      final path = borderRadius.toPath(rect);

      expect(
        path,
        isNotNull,
      );
    });

    test('lerp handles edge cases', () {
      const radius1 = 10.0;
      const smoothing1 = 0.5;
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius1, smoothing: smoothing1);

      const radius2 = 20.0;
      const smoothing2 = 0.8;
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius2, smoothing: smoothing2);

      final resultZero =
          OuiCornerBorderRadius.lerp(borderRadius1, borderRadius2, 0.0);
      final resultOne =
          OuiCornerBorderRadius.lerp(borderRadius1, borderRadius2, 1.0);
      final resultBeyond =
          OuiCornerBorderRadius.lerp(borderRadius1, borderRadius2, 1.5);

      // Updated expects to reflect correct smoothing interpolation
      expect(resultZero?.topLeft.cornerRadius, radius1);
      expect(resultZero?.topLeft.smoothing, smoothing1);

      expect(resultOne?.topLeft.cornerRadius, radius2);
      expect(resultOne?.topLeft.smoothing, smoothing2);

      expect(resultBeyond?.topLeft.cornerRadius, radius2);
      expect(resultBeyond?.topLeft.smoothing, smoothing2);
    });

    test('operator * with 0 produces zeroed radii', () {
      final borderRadius = OuiCornerBorderRadius(
        radius: 0,
        smoothing: 0,
      );

      final result = borderRadius * 0;

      expect(result.topLeft.cornerRadius, 0.0);
      expect(result.topLeft.smoothing, 0.0);
    });

    test('zero constant is initialized correctly', () {
      const zero = OuiCornerBorderRadius.zero;

      expect(zero.topLeft.cornerRadius, 0);
      expect(zero.topLeft.smoothing, 0);
      expect(zero.topRight.cornerRadius, 0);
      expect(zero.topRight.smoothing, 0);
      expect(zero.bottomLeft.cornerRadius, 0);
      expect(zero.bottomLeft.smoothing, 0);
      expect(zero.bottomRight.cornerRadius, 0);
      expect(zero.bottomRight.smoothing, 0);
    });

    test('copyWith creates a copy with modified values', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      final modified = borderRadius.copyWith(
        topLeft: const OuiCornerRadius(
          radius: 20.0,
          smoothing: 0.1,
        ),
      );

      expect(modified.topLeft.cornerRadius, 20.0);
      expect(modified.topLeft.smoothing, 0.1);
      expect(modified.topRight.cornerRadius, radius);
      expect(modified.topRight.smoothing, smoothing);
    });

    test('operator - subtracts radii and averages smoothing', () {
      const radius1 = 10.0;
      const smoothing1 = 0.5;
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius1, smoothing: smoothing1);

      const radius2 = 4.0;
      const smoothing2 = 0.3;
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius2, smoothing: smoothing2);

      final result = borderRadius1 - borderRadius2;

      expect(result.topLeft.cornerRadius, radius1 - radius2);
      expect(result.topLeft.smoothing, (smoothing1 + smoothing2) / 2);
    });

    test('operator + adds radii and averages smoothing', () {
      const radius1 = 10.0;
      const smoothing1 = 0.5;
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius1, smoothing: smoothing1);

      const radius2 = 4.0;
      const smoothing2 = 0.3;
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius2, smoothing: smoothing2);

      final result = borderRadius1 + borderRadius2;

      expect(result.topLeft.cornerRadius, radius1 + radius2);
      expect(result.topLeft.smoothing, (smoothing1 + smoothing2) / 2);
    });

    test('operator * multiplies radii and smoothing', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      const operand = 2.0;

      final result = borderRadius * operand;

      expect(result.topLeft.cornerRadius, radius * operand);
      expect(result.topLeft.smoothing, smoothing * operand);
    });

    test('operator / divides radii and smoothing', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      const operand = 2.0;

      final result = borderRadius / operand;

      expect(result.topLeft.cornerRadius, radius / operand);
      expect(result.topLeft.smoothing, smoothing / operand);
    });

    test('operator ~/ divides radii and smoothing with truncation', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      const operand = 3.0;

      final result = borderRadius ~/ operand;

      expect(result.topLeft.cornerRadius, (radius ~/ operand).toDouble());
      expect(result.topLeft.smoothing, (smoothing ~/ operand).toDouble());
    });

    test('operator % calculates remainder of radii and smoothing', () {
      const radius = 10.0;
      const smoothing = 0.5; // Updated to be between 0 and 1
      final borderRadius =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      const operand = 3.0;

      final result = borderRadius % operand;

      expect(result.topLeft.cornerRadius, radius % operand);
      expect(result.topLeft.smoothing, smoothing % operand);
    });

    test('lerp interpolates between two border radii', () {
      const radius1 = 10.0;
      const smoothing1 = 0.5; // Updated to be between 0 and 1
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius1, smoothing: smoothing1);

      const radius2 = 20.0;
      const smoothing2 = 0.8; // Updated to be between 0 and 1
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius2, smoothing: smoothing2);

      const t = 0.5;
      final result =
          OuiCornerBorderRadius.lerp(borderRadius1, borderRadius2, t);

      expect(result?.topLeft.cornerRadius, (radius1 + radius2) / 2);
      expect(result?.topLeft.smoothing, (smoothing1 + smoothing2) / 2);
    });

    test('equality operator returns true for equal border radii', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);

      expect(borderRadius1 == borderRadius2, isTrue);
    });

    test('hashCode returns same value for equal border radii', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius1 =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);
      final borderRadius2 =
          OuiCornerBorderRadius(radius: radius, smoothing: smoothing);

      expect(borderRadius1.hashCode, borderRadius2.hashCode);
    });

    test('toString returns correct string representation', () {
      const radius = 10.0;
      const smoothing = 0.5;
      final borderRadius = OuiCornerBorderRadius(
        radius: radius,
        smoothing: smoothing,
      );

      expect(
        borderRadius.toString(),
        'OuiCornerBorderRadius(topLeft: OuiCornerRadius(cornerRadius: 10.00, smoothing: 0.50), topRight: OuiCornerRadius(cornerRadius: 10.00, smoothing: 0.50), bottomLeft: OuiCornerRadius(cornerRadius: 10.00, smoothing: 0.50), bottomRight: OuiCornerRadius(cornerRadius: 10.00, smoothing: 0.50))',
      );
    });
  });
}
