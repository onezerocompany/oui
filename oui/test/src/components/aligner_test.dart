import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/aligner.dart';
import 'package:oui/src/core/geometry.dart';

void main() {
  // Helper function to create a golden test for a given flow direction
  Future<void> testAlignerFlowDirection(
    WidgetTester tester,
    FlowDirection direction,
    String description,
  ) async {
    final children = List<Widget>.generate(
      5,
      (index) => Container(
        width: 50,
        height: 50,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Aligner(
            flowDirection: direction,
            children: children,
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Aligner),
      matchesGoldenFile('goldens/aligner_$description.png'),
    );
  }

  // Define golden tests for each flow direction
  testWidgets('Aligner - topToBottom', (WidgetTester tester) async {
    await testAlignerFlowDirection(
      tester,
      FlowDirection.topToBottom,
      'top_to_bottom',
    );
  });

  testWidgets('Aligner - bottomToTop', (WidgetTester tester) async {
    await testAlignerFlowDirection(
      tester,
      FlowDirection.bottomToTop,
      'bottom_to_top',
    );
  });

  testWidgets('Aligner - leftToRight', (WidgetTester tester) async {
    await testAlignerFlowDirection(
      tester,
      FlowDirection.leftToRight,
      'left_to_right',
    );
  });

  testWidgets('Aligner - rightToLeft', (WidgetTester tester) async {
    await testAlignerFlowDirection(
      tester,
      FlowDirection.rightToLeft,
      'right_to_left',
    );
  });
}
