import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app/oui_app_context.dart';
import '../config/config_container.dart';
import '../utils/oui_sides.dart';
import '../router/oui_path_match.dart';

import 'oui_scaffold_rail.dart';

class OuiScaffoldConfig {
  final ConfigContainer<OuiRectSide, OuiScaffoldRailConfig> rails;

  const OuiScaffoldConfig({
    this.rails = const {
      OuiRectSide.top: OuiScaffoldRailConfig(),
      OuiRectSide.bottom: OuiScaffoldRailConfig(),
      OuiRectSide.left: OuiScaffoldRailConfig(),
      OuiRectSide.right: OuiScaffoldRailConfig(),
    },
  });
}

class OuiScaffoldDivider extends StatelessWidget {
  const OuiScaffoldDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000),
      width: 1,
    );
  }
}

class OuiScaffold extends HookConsumerWidget {
  final OuiPathMatch currentPath;

  const OuiScaffold(
    this.currentPath, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.config.backdropColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          // if (config.rails[OuiRectSide.left].enabled)
          const OuiScaffoldRail(OuiRectSide.left),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // if (config.rails.top.enabled)
                const OuiScaffoldRail(OuiRectSide.top),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: currentPath.screens
                        .expand(
                          (screen) => [
                            Expanded(
                              child: screen.builder(context),
                            ),
                            if (screen != currentPath.screens.last)
                              const OuiScaffoldDivider(),
                          ],
                        )
                        .toList(growable: false),
                  ),
                ),
                // if (config.rails.bottom.enabled)
                const OuiScaffoldRail(OuiRectSide.bottom),
                // _buildScreens(context, ref),
              ],
            ),
          ),
          // if (config.rails.right.enabled)
          const OuiScaffoldRail(OuiRectSide.right),
        ],
      ),
    );
  }
}
