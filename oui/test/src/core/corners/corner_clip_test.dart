import 'package:flutter/widgets.dart'
    show
        Clip,
        Color,
        Column,
        Container,
        Directionality,
        SingleChildScrollView,
        SizedBox,
        TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/corners.dart';

void main() {
  group('ClipCornerRect', () {
    testWidgets('builds a clipped widget', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ClipCornerRect(
            radius: CornerBorderRadius.zero,
            child: Container(),
          ),
        ),
      );
      expect(find.byType(ClipCornerRect), findsOneWidget);
    });

    testWidgets('applies a non-zero radius', (tester) async {
      await tester.pumpWidget(
        const ClipCornerRect(
          radius: CornerBorderRadius.all(
            CornerRadius(
              radius: 10,
              smoothing: 1,
            ),
          ),
          child: SizedBox(),
        ),
      );
      expect(find.byType(ClipCornerRect), findsOneWidget);
    });

    testWidgets('handles null child', (tester) async {
      await tester.pumpWidget(
        const ClipCornerRect(
          radius: CornerBorderRadius.all(
            CornerRadius(
              radius: 10,
              smoothing: 1,
            ),
          ),
          child: null,
        ),
      );
      expect(find.byType(ClipCornerRect), findsOneWidget);
    });

    testWidgets('respects clipBehavior', (tester) async {
      for (var clipBehavior in Clip.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: ClipCornerRect(
              radius: CornerBorderRadius.zero,
              clipBehavior: clipBehavior,
              child: Container(),
            ),
          ),
        );
        expect(find.byType(ClipCornerRect), findsOneWidget);
      }
    });

    testWidgets('matches golden file', (tester) async {
      await tester.pumpWidget(
        ClipCornerRect(
          radius: const CornerBorderRadius.all(
            CornerRadius(
              radius: 100,
              smoothing: 1,
            ),
          ),
          child: Container(color: const Color(0xFF0000FF)),
        ),
      );
      await expectLater(
        find.byType(ClipCornerRect),
        matchesGoldenFile('goldens/clip_corner_rect.png'),
      );
    });

    testWidgets('handles large child trees efficiently', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ClipCornerRect(
            radius: CornerBorderRadius.zero,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  1000,
                  (index) =>
                      Container(height: 1, color: const Color(0xFF0000FF)),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsNWidgets(1000));
    });
  });
}
