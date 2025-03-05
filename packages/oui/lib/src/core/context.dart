import 'dart:ui' show Brightness;

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        InheritedWidget,
        Localizations,
        MediaQuery,
        MediaQueryData,
        State,
        StatefulWidget,
        Widget;
import 'package:flutter/widgets.dart' as widgets show Locale;
import 'package:oui/src/core/auth.dart' show AuthProvider;
import 'package:oui/src/core/colors.dart'
    show ColorPalette, DynamicTheme, DynamicThemeContext;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/locales.dart' show Locale, LocaleContext;
import 'package:oui/src/core/responsive.dart'
    show Density, ResponsiveContext, ScreenOrientation, ScreenSize;
import 'package:oui/src/core/routing.dart' show Router;
import 'package:oui/src/core/screen_registry.dart' show ScreenRegistry;
import 'package:oui/src/core/typography.dart' show Typography;

class StaticContext {
  const StaticContext({
    required this.config,
    required this.router,
    required this.palette,
    required this.typography,
    required this.registry,
    this.auth,
  });

  factory StaticContext.forConfig(Config config) {
    final registry = ScreenRegistry.fromConfig(config);
    return StaticContext(
      config: config,
      router: Router(registry, config),
      palette: ColorPalette.fromConfig(config.colors),
      typography: Typography.fromConfig(config.typography),
      registry: registry,
      auth: config.auth?.call(),
    );
  }

  final Config config;
  final Router router;
  final ColorPalette palette;
  final Typography typography;
  final ScreenRegistry registry;
  final AuthProvider? auth;

  @override
  int get hashCode => Object.hash(
        config,
        router,
        palette,
        typography,
        registry,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StaticContext &&
            other.config == config &&
            other.router == router &&
            other.palette == palette &&
            other.typography == typography &&
            other.registry == registry);
  }

  /// Creates a copy of this StaticContext with the specified fields replaced.
  StaticContext copyWith({
    Config? config,
    Router? router,
    ColorPalette? palette,
    Typography? typography,
    ScreenRegistry? registry,
  }) {
    return StaticContext(
      config: config ?? this.config,
      router: router ?? this.router,
      palette: palette ?? this.palette,
      typography: typography ?? this.typography,
      registry: registry ?? this.registry,
    );
  }
}

class DynamicContext extends StaticContext
    implements ResponsiveContext, DynamicThemeContext, LocaleContext {
  const DynamicContext({
    required super.config,
    required super.router,
    required super.palette,
    required super.typography,
    required super.registry,
    required this.build,
    required this.locale,
    required this.width,
    required this.height,
    required this.orientation,
    required this.density,
    required this.theme,
  });

  static DynamicTheme _dynamicTheme(MediaQueryData mediaQuery) {
    final brightness = mediaQuery.platformBrightness;
    if (brightness == Brightness.dark) {
      return DynamicTheme.dark;
    } else {
      return DynamicTheme.light;
    }
  }

  factory DynamicContext.forContexts(
    StaticContext staticContext,
    BuildContext buildContext,
  ) {
    // Safely access MediaQuery with fallback
    final MediaQueryData mediaQuery =
        MediaQuery.maybeOf(buildContext) ?? const MediaQueryData();
    final screenSize = mediaQuery.size;

    // Safely get the locale with fallback
    widgets.Locale flutterLocale;
    try {
      flutterLocale = Localizations.localeOf(buildContext);
    } catch (e) {
      flutterLocale = const widgets.Locale('en');
    }

    return DynamicContext(
      config: staticContext.config,
      router: staticContext.router,
      palette: staticContext.palette,
      typography: staticContext.typography,
      registry: staticContext.registry,
      build: buildContext,
      locale: Locale.fromFlutterLocale(flutterLocale),
      width:
          staticContext.config.responsive.horizontal.sizeFor(screenSize.width),
      height:
          staticContext.config.responsive.vertical.sizeFor(screenSize.height),
      orientation: screenSize.width > screenSize.height
          ? ScreenOrientation.landscape
          : ScreenOrientation.portrait,
      density: Density.medium,
      theme: _dynamicTheme(mediaQuery),
    );
  }

  final BuildContext build;

  @override
  final Locale locale;

  @override
  final ScreenSize width;

  @override
  final ScreenSize height;

  @override
  final ScreenOrientation orientation;

  @override
  final Density density;

  @override
  final DynamicTheme theme;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        locale,
        width,
        height,
        orientation,
        density,
        theme,
        build,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DynamicContext &&
            super == other &&
            other.locale == locale &&
            other.width == width &&
            other.height == height &&
            other.orientation == orientation &&
            other.density == density &&
            other.theme == theme &&
            other.build == build);
  }

  @override
  DynamicContext copyWith({
    Config? config,
    Router? router,
    ColorPalette? palette,
    Typography? typography,
    ScreenRegistry? registry,
    BuildContext? build,
    Locale? locale,
    ScreenSize? width,
    ScreenSize? height,
    ScreenOrientation? orientation,
    Density? density,
    DynamicTheme? theme,
  }) {
    return DynamicContext(
      config: config ?? this.config,
      router: router ?? this.router,
      palette: palette ?? this.palette,
      typography: typography ?? this.typography,
      registry: registry ?? this.registry,
      build: build ?? this.build,
      locale: locale ?? this.locale,
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      density: density ?? this.density,
      theme: theme ?? this.theme,
    );
  }

  static DynamicContext of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ContextProvider>();
    assert(inherited != null, 'No DynamicContext found in context');
    return inherited!.context;
  }
}

typedef ContextCondition = bool Function(DynamicContext context);

class _ContextProvider extends InheritedWidget {
  final DynamicContext context;

  const _ContextProvider({
    required this.context,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return context != (oldWidget as _ContextProvider).context;
  }
}

class ContextProvider extends StatefulWidget {
  final Config config;

  const ContextProvider({
    super.key,
    required this.config,
    required this.builder,
  });

  @override
  State<ContextProvider> createState() => _ContextProviderState();

  final Widget Function(DynamicContext context) builder;
}

class _ContextProviderState extends State<ContextProvider> {
  late StaticContext staticContext;
  late DynamicContext dynamicContext;

  MediaQueryData? _currentMediaQuery;
  widgets.Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    staticContext = StaticContext.forConfig(widget.config);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;

    staticContext = StaticContext.forConfig(widget.config);

    // Safely access MediaQuery and Locale with fallbacks
    _currentMediaQuery = MediaQuery.maybeOf(context);
    try {
      _currentLocale = Localizations.localeOf(context);
    } catch (e) {
      _currentLocale = const widgets.Locale('en'); // Default locale as fallback
    }

    _initializeDynamicContext();
  }

  void _initializeDynamicContext() {
    dynamicContext = DynamicContext.forContexts(
      staticContext,
      context,
    );
  }

  @override
  void didUpdateWidget(ContextProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      staticContext = StaticContext.forConfig(widget.config);
      _recreateContextIfNeeded();
    }
  }

  void _recreateContextIfNeeded() {
    widgets.Locale? newLocale;
    MediaQueryData? newMediaQuery;

    try {
      newLocale = Localizations.localeOf(context);
    } catch (e) {
      newLocale = const widgets.Locale('en'); // Default locale as fallback
    }

    newMediaQuery = MediaQuery.maybeOf(context);

    if (newLocale != _currentLocale || newMediaQuery != _currentMediaQuery) {
      setState(() {
        _initializeDynamicContext();
      });
    }

    _currentLocale = newLocale;
    _currentMediaQuery = newMediaQuery;
  }

  @override
  Widget build(BuildContext context) {
    return _ContextProvider(
      context: dynamicContext,
      child: widget.builder(dynamicContext),
    );
  }
}
