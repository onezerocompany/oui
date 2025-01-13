import 'package:flutter/rendering.dart' as rendering show Alignment;
import 'package:flutter/widgets.dart'
    show LinearGradient, RadialGradient, SweepGradient;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors.dart';
import 'package:oui/src/core/geometry.dart';

const customRed = Color.fromRGB(1, 0, 0);
const customBlue = Color.fromRGB(0, 0, 1);
const customGreen = Color.fromRGB(0, 1, 0);

void main() {
  group('Gradient', () {
    test('linear gradient creation', () {
      final gradient = Gradient.linear(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as LinearGradient;

      expect(
        flutterGradient.colors,
        [customRed.uiColor, customBlue.uiColor],
      );
      expect(flutterGradient.stops, [0.0, 1.0]);
      expect(flutterGradient.begin, rendering.Alignment.topCenter);
      expect(flutterGradient.end, rendering.Alignment.bottomCenter);
    });

    test('radial gradient creation', () {
      final gradient = Gradient.radial(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as RadialGradient;

      expect(
        flutterGradient.colors,
        [customRed.uiColor, customBlue.uiColor],
      );
      expect(flutterGradient.stops, [0.0, 1.0]);
      expect(flutterGradient.radius, 1);
    });

    test('sweep gradient creation', () {
      final gradient = Gradient.sweep(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as SweepGradient;

      expect(
        flutterGradient.colors,
        [customRed.uiColor, customBlue.uiColor],
      );
      expect(flutterGradient.stops, [0.0, 1.0]);
      expect(flutterGradient.startAngle, 0);
      expect(flutterGradient.endAngle, 2 * 3.14);
    });

    // Additional test cases
    test('linear gradient with multiple stops', () {
      final gradient = Gradient.linear(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(0.5, customGreen),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as LinearGradient;

      expect(
        flutterGradient.colors,
        [
          customRed.uiColor,
          customGreen.uiColor,
          customBlue.uiColor,
        ],
      );
      expect(flutterGradient.stops, [0.0, 0.5, 1.0]);
    });

    test('radial gradient with multiple stops', () {
      final gradient = Gradient.radial(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(0.5, customGreen),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as RadialGradient;

      expect(
        flutterGradient.colors,
        [
          customRed.uiColor,
          customGreen.uiColor,
          customBlue.uiColor,
        ],
      );
      expect(flutterGradient.stops, [0.0, 0.5, 1.0]);
    });

    test('sweep gradient with multiple stops', () {
      final gradient = Gradient.sweep(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(0.5, customGreen),
          GradientStop(1.0, customBlue),
        ],
      );

      final flutterGradient = gradient.uiGradient as SweepGradient;

      expect(
        flutterGradient.colors,
        [
          customRed.uiColor,
          customGreen.uiColor,
          customBlue.uiColor,
        ],
      );
      expect(flutterGradient.stops, [0.0, 0.5, 1.0]);
    });

    test('linear gradient with reversed direction', () {
      final gradient = Gradient.linear(
        stops: [
          GradientStop(0.0, customRed),
          GradientStop(1.0, customBlue),
        ],
        direction: FlowDirection.rightToLeft,
      );

      final flutterGradient = gradient.uiGradient as LinearGradient;

      expect(
        flutterGradient.colors,
        [customRed.uiColor, customBlue.uiColor],
      );
      expect(flutterGradient.stops, [0.0, 1.0]);
      expect(flutterGradient.begin, rendering.Alignment.centerRight);
      expect(flutterGradient.end, rendering.Alignment.centerLeft);
    });
  });
}
