import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, State, StatefulWidget, Widget;
import 'package:oui/src/core/shared/dynamic_container.dart';

class DynamicAppContext extends InheritedWidget {
  final DynamicTheme theme;

  const DynamicAppContext({
    super.key,
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return theme != (oldWidget as DynamicAppContext).theme;
  }

  static DynamicAppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamicAppContext>();
  }
}

class DynamicAppContextProvider extends StatefulWidget {
  final Widget child;

  const DynamicAppContextProvider({
    super.key,
    required this.child,
  });

  @override
  State<DynamicAppContextProvider> createState() =>
      _DynamicAppContextProviderState();
}

class _DynamicAppContextProviderState extends State<DynamicAppContextProvider> {
  DynamicTheme get theme => DynamicTheme.light;

  @override
  Widget build(BuildContext context) {
    return DynamicAppContext(
      theme: theme,
      child: widget.child,
    );
  }
}

extension DynamicAppContextExtension on BuildContext {
  DynamicTheme get theme {
    return DynamicAppContext.of(this)?.theme ?? DynamicTheme.light;
  }
}
