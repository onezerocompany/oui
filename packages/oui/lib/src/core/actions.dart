import 'package:oui/src/core/context.dart' show DynamicContext;
import 'package:oui/src/core/locales.dart' show Locale;
import 'package:oui/src/core/metadata.dart' show Metadata;

enum ActionLocation {
  custom(0);

  final int position;
  const ActionLocation(this.position);
}

class ActionMetadata extends Metadata {
  final List<ActionLocation> locations;

  const ActionMetadata({
    required super.id,
    required super.name,
    this.locations = const [ActionLocation.custom],
  });
}

class ActionContext extends DynamicContext {
  const ActionContext({
    required super.config,
    required super.router,
    required super.palette,
    required super.typography,
    required super.registry,
    required super.build,
    required super.locale,
    required super.width,
    required super.height,
    required super.orientation,
    required super.density,
    required super.theme,
  });

  factory ActionContext.from(DynamicContext context) {
    return ActionContext(
      config: context.config,
      router: context.router,
      palette: context.palette,
      typography: context.typography,
      registry: context.registry,
      build: context.build,
      locale: context.locale,
      width: context.width,
      height: context.height,
      orientation: context.orientation,
      density: context.density,
      theme: context.theme,
    );
  }
}

typedef ActionRunner = Future<void> Function(ActionContext context);

class Action {
  final Metadata metadata;
  final ActionRunner runner;

  const Action(
    this.runner, {
    required this.metadata,
  });

  Future<void> execute(ActionContext context) async {
    print("Executing action ${metadata.id}");
    await runner(context);
  }

  static Action navigate(String path) => Action(
        (context) async {
          await context.router.navigate(context, path: path);
        },
        metadata: const ActionMetadata(
          id: "uri_navigate",
          name: {Locale.any: "Navigate to URL"},
        ),
      );
}
