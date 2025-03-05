import 'package:flutter/widgets.dart'
    show
        BuildContext,
        StatelessWidget,
        Widget,
        WidgetsApp,
        WidgetsFlutterBinding;
import 'package:flutter/widgets.dart' as widgets show runApp;
import 'package:oui/src/core/context.dart';
import 'package:oui/src/core/state.dart' show State;

import 'config.dart';

class _OuiWidgetApp extends StatelessWidget {
  const _OuiWidgetApp(this.context);

  final DynamicContext context;

  @override
  Widget build(BuildContext buildContext) {
    return WidgetsApp.router(
      routerConfig: context.router,
      color: context.palette.levels
          .get(context.theme)
          .get(0)
          .get(State.normal)
          .accented(0)
          .surface
          .uiColor,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'oui_app',
      supportedLocales: context.config.locales.map(
        (locale) => locale.flutterLocale,
      ),
    );
  }
}

class OuiApp extends StatelessWidget {
  const OuiApp({
    super.key,
    required this.config,
  });

  final Config config;

  @override
  Widget build(BuildContext context) {
    return ContextProvider(
      config: config,
      builder: (DynamicContext dynamicContext) {
        return _OuiWidgetApp(dynamicContext);
      },
    );
  }
}

void runOuiApp(Config config) {
  WidgetsFlutterBinding.ensureInitialized();
  widgets.runApp(OuiApp(config: config));
}
