import 'package:flutter/widgets.dart' show InheritedWidget;
import 'package:oui/src/core/geometry/size.dart';

import '../../core/shared/dynamic_container.dart';

class AppDynamicContext extends InheritedWidget {
  final DynamicTheme theme;
  final Size screenSize;

  const AppDynamicContext({
    super.key,
    required this.theme,
    required this.screenSize,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppDynamicContext &&
        (oldWidget.theme != theme || oldWidget.screenSize != screenSize);
  }
}
