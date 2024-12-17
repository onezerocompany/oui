import 'package:oui/oui.dart';

class OuiScaffoldRailConfig {
  final Background? background;
  final OuiBorder border;
  final double size;
  final double expandedSize;

  const OuiScaffoldRailConfig({
    this.border = const OuiBorder(thickness: 1, color: Color(0xFF000000)),
    this.background,
    this.size = 72,
    this.expandedSize = 330,
  });
}

class OuiScaffoldRailContainer {
  final OuiScaffoldRailConfig top;
  final OuiScaffoldRailConfig bottom;
  final OuiScaffoldRailConfig left;
  final OuiScaffoldRailConfig right;

  const OuiScaffoldRailContainer({
    this.top = const OuiScaffoldRailConfig(),
    this.bottom = const OuiScaffoldRailConfig(),
    this.left = const OuiScaffoldRailConfig(),
    this.right = const OuiScaffoldRailConfig(),
  });
}

class OuiScaffoldRail extends StatelessWidget {
  final OuiRectSide side;

  const OuiScaffoldRail(
    this.side, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        context.config.scaffold.rails[side]; // Access the correct config

    final List<Widget> items = [];
    final decoration = BoxDecoration(
      border: config?.border.borderFor(
        [side.opposite],
      ),
    );

    if (side.direction.isHorizontal) {
      return Container(
        height: 72,
        decoration: decoration,
        child: Row(
          children: items,
        ),
      );
    } else {
      return Container(
        width: 72,
        decoration: decoration,
        child: Column(
          children: items,
        ),
      );
    }
  }
}
