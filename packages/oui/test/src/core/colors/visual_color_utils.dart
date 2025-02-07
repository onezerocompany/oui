import 'package:flutter/material.dart'
    show
        Column,
        Container,
        EdgeInsets,
        MaterialApp,
        Padding,
        Row,
        Scaffold,
        Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart' hide Scaffold, Size;

void visualColorTest(
  String fileName,
  String description,
  List<List<Color>> Function() colors,
) {
  testWidgets(description, (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final colorList = colors();
    final columns = colorList.length;
    final rows = colorList.map((e) => e.length).reduce((a, b) => a > b ? a : b);

    final size = Size(
      100 * columns.toDouble() + 40,
      100 * rows.toDouble() + 40,
    );
    await tester.binding.setSurfaceSize(size);

    // Create a grid of colors 3 wide each cell 100x100
    final grid = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: colorList
            .map(
              (samples) => Column(
                children: samples
                    .map(
                      (color) => Container(
                        width: 100,
                        height: 100,
                        color: color.uiColor,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: grid,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/color_test_$fileName.png'),
    );
  });
}
