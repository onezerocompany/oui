import 'package:flutter/widgets.dart'
    show BuildContext, FlutterError, InheritedWidget;

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
    final boxLevel = BoxLevel.of(this);
    if (boxLevel == null) {
      throw FlutterError(
        'BoxLevel not found in context.\nThe context used to retrieve the value must be a descendant of BoxLevel.',
      );
    }
    return boxLevel.level;
  }
}
