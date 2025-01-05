import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        Color,
        Container,
        Directionality,
        ShapeDecoration,
        TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/corners/corner_border.dart';
import 'package:oui/src/components/corners/corner_border_radius.dart';
import 'package:oui/src/components/corners/corner_radius.dart';

void main() {
  group('CornerBorderRadius', () {
    test('constructor initializes correctly', () {
      const topLeft = CornerRadius(radius: 10.0, smoothing: 0.5);
      const topRight = CornerRadius(radius: 10.0, smoothing: 0.5);
      const bottomLeft = CornerRadius(radius: 10.0, smoothing: 0.5);
      const bottomRight = CornerRadius(radius: 10.0, smoothing: 0.5);
      const borderRadius = CornerBorderRadius.only(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      );

      expect(borderRadius.topLeft, topLeft);
      expect(borderRadius.topRight, topRight);
      expect(borderRadius.bottomLeft, bottomLeft);
      expect(borderRadius.bottomRight, bottomRight);
    });

    testWidgets('CornerBorderRadius matches golden file', (tester) async {
      const borderRadius = CornerBorderRadius.all(
        CornerRadius(radius: 20.0, smoothing: 0.5),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            decoration: const ShapeDecoration(
              color: Color(0xFF00FF00),
              shape: CornerBorder(
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Container),
        matchesGoldenFile('goldens/corner_border_radius.png'),
      );
    });
  });
}
