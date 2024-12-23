import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

void main() {
  testWidgets('ClipOuiCornerRect builds a clipped widget', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ClipOuiCornerRect(
          radius: OuiCornerBorderRadius.zero,
          child: Container(),
        ),
      ),
    );
    expect(find.byType(ClipOuiCornerRect), findsOneWidget);
  });

  testWidgets('ClipOuiCornerRect applies a non-zero radius', (tester) async {
    await tester.pumpWidget(
      const ClipOuiCornerRect(
        radius: OuiCornerBorderRadius.all(
          OuiCornerRadius(
            radius: 10,
            smoothing: 1,
          ),
        ),
        child: SizedBox(),
      ),
    );
    expect(find.byType(ClipOuiCornerRect), findsOneWidget);
  });

  testWidgets('ClipOuiCornerRect handles null child', (tester) async {
    await tester.pumpWidget(
      const ClipOuiCornerRect(
        radius: OuiCornerBorderRadius.all(
          OuiCornerRadius(
            radius: 10,
            smoothing: 1,
          ),
        ),
        child: null,
      ),
    );
    expect(find.byType(ClipOuiCornerRect), findsOneWidget);
  });

  testWidgets('ClipOuiCornerRect respects clipBehavior', (tester) async {
    for (var clipBehavior in Clip.values) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ClipOuiCornerRect(
            radius: OuiCornerBorderRadius.zero,
            clipBehavior: clipBehavior,
            child: Container(),
          ),
        ),
      );
      expect(find.byType(ClipOuiCornerRect), findsOneWidget);
    }
  });

  testWidgets('ClipOuiCornerRect matches golden file', (tester) async {
    await tester.pumpWidget(
      ClipOuiCornerRect(
        radius: const OuiCornerBorderRadius.all(
          OuiCornerRadius(
            radius: 100,
            smoothing: 1,
          ),
        ),
        child: Container(color: const Color(0xFF0000FF)),
      ),
    );
    await expectLater(
      find.byType(ClipOuiCornerRect),
      matchesGoldenFile('goldens/clip_oui_corner_rect.png'),
    );
  });

  testWidgets('ClipOuiCornerRect handles large child trees efficiently',
      (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ClipOuiCornerRect(
          radius: OuiCornerBorderRadius.zero,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                1000,
                (index) => Container(height: 1, color: const Color(0xFF0000FF)),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Container), findsNWidgets(1000));
  });
}
