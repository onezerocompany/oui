import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/config/config.dart';
import '../../core/router/router.dart';

  


class AppContext extends InheritedWidget {
  final Config config;
  final Router router;

  const AppContext({
    super.key,
    required this.config,
    required this.router,
    required super.child,
  });

  static AppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppContext>();
  }

  @override
  bool updateShouldNotify(AppContext oldWidget) {
    return router != oldWidget.router || config != oldWidget.config;
  }
}

class AppContextProvider extends HookWidget {
  const AppContextProvider({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    const test = use
  }
}

extension AppContextExtension on BuildContext {
  T _getFromContext<T>(T Function(AppContext) extractor) {
    final context = AppContext.of(this);
    if (context == null) {
      throw FlutterError(
        'AppContext not found in context. Make sure to wrap your app with OuiApp.\nThe context used to retrieve the value must be a descendant of AppContext.',
      );
    }
    return extractor(context);
  }

  Config get config {
    return _getFromContext((context) => context.config);
  }

  Router get router {
    return _getFromContext((context) => context.router);
  }
}
