import 'package:oui/oui.dart';

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
        children: [
          // if (config.rails[OuiRectSide.left].enabled)
          const OuiScaffoldRail(OuiRectSide.left),
          Expanded(
            child: Column(
              children: [
                // if (config.rails.top.enabled)
                const OuiScaffoldRail(OuiRectSide.top),
                Expanded(
                  child: currentPath.screens.last.builder(context),
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
