import 'package:flutter/widgets.dart' show BuildContext, InheritedWidget;

class BoxLevel extends InheritedWidget {
  final int level;

  const BoxLevel({
    super.key,
    required this.level,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return level != (oldWidget as BoxLevel).level;
  }

  static BoxLevel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BoxLevel>();
  }
}

extension BoxLevelExtension on BuildContext {
  int get boxLevel {
    return BoxLevel.of(this)?.level ?? 0;
  }
}
