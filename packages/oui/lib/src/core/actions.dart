import 'package:oui/src/core/metadata.dart';

import 'locales.dart' show Locale;
import 'screen.dart' show Screen;

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

class ActionContext {}

typedef ActionRunner = Future<void> Function(ActionContext context);

class Action {
  final Metadata metadata;
  final ActionRunner runner;

  const Action(
    this.runner, {
    required this.metadata,
  });

  static Action navigate(Screen screen) {
    return Action(
      (context) async {},
      metadata: ActionMetadata(
        id: "navigate_to_${screen.metadata.id}",
        name: {Locale.any: "Navigate to ${screen.metadata.name}"},
      ),
    );
  }

  Future<void> execute(ActionContext context) async {
    await runner(context);
  }
}
