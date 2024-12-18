import 'package:oui/oui.dart';

class OuiAppContext extends InheritedWidget {
  final OuiConfig config;
  final OuiRouter router;

  const OuiAppContext({
    super.key,
    required this.config,
    required this.router,
    required super.child,
  });

  static OuiAppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OuiAppContext>();
  }

  @override
  bool updateShouldNotify(OuiAppContext oldWidget) {
    return router != oldWidget.router || config != oldWidget.config;
  }
}

extension OuiAppContextExtension on BuildContext {
  T _getFromContext<T>(T Function(OuiAppContext) extractor) {
    final context = OuiAppContext.of(this);
    if (context == null) {
      throw FlutterError(
        'OuiAppContext not found in context. Make sure to wrap your app with OuiApp.\nThe context used to retrieve the value must be a descendant of OuiAppContext.',
      );
    }
    return extractor(context);
  }

  OuiConfig get config {
    return _getFromContext((context) => context.config);
  }

  OuiRouter get router {
    return _getFromContext((context) => context.router);
  }
}
