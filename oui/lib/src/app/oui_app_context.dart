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
    return router != oldWidget.router;
  }
}

extension OuiAppContextExtension on BuildContext {
  OuiConfig get config {
    return OuiAppContext.of(this)!.config;
  }

  OuiRouter get router {
    return OuiAppContext.of(this)!.router;
  }
}
