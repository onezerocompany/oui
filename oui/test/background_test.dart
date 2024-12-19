import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/utils/background.dart';

void main() {
  testWidgets('Background with color', (WidgetTester tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => Background.color(const Color(0xFFFF0000)),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    expect(
      (container.decoration as BoxDecoration?)?.color,
      const Color(0xFFFF0000),
    );
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Background with gradient', (WidgetTester tester) async {
    const gradient = LinearGradient(
      colors: [Color(0xFFFF0000), Color(0xFF0000FF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => Background.gradient(gradient),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final boxDecoration = container.decoration as BoxDecoration?;
    expect(boxDecoration?.gradient, gradient);
  });

  testWidgets('Background with custom widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => Background.custom(
          (context) => const Text('Custom Widget'),
        ),
      ),
    );

    expect(find.text('Custom Widget'), findsOneWidget);
  });

  testWidgets('Background with color and custom widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => Background.custom(
          (context) => const Text('Custom Widget'),
          color: const Color(0xFFFF0000),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    expect(
      (container.decoration as BoxDecoration?)?.color,
      const Color(0xFFFF0000),
    );
    expect(find.text('Custom Widget'), findsOneWidget);
  });

  testWidgets('Background with gradient and custom widget',
      (WidgetTester tester) async {
    const gradient = LinearGradient(
      colors: [Color(0xFFFF0000), Color(0xFF0000FF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) => Background.custom(
          (context) => const Text('Custom Widget'),
          gradient: gradient,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final boxDecoration = container.decoration as BoxDecoration?;
    expect(boxDecoration?.gradient, gradient);
    expect(find.text('Custom Widget'), findsOneWidget);
  });
}
