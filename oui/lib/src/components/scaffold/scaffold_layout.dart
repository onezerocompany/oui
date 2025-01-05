import 'package:flutter/widgets.dart'
    show BuildContext, LayoutBuilder, StatelessWidget, Widget;

import '../../core/geometry/size.dart';
import '../../core/router/path_match.dart';
import '../app/static_app_context.dart';
import '../screen/screen.dart';

class ScaffoldLayout {
  final Size size;
  final List<Screen> panels;
  final List<Screen> sheets;
  final List<Screen> modals;

  ScaffoldLayout({
    required this.size,
    required this.panels,
    required this.sheets,
    required this.modals,
  });
}

class ScaffoldLayoutBuilder extends StatelessWidget {
  final PathMatch currentPath;
  final Function(BuildContext context, ScaffoldLayout layout) builder;

  const ScaffoldLayoutBuilder({
    required this.currentPath,
    required this.builder,
    super.key,
  });

  ScaffoldLayout _buildLayout(
    Size size,
    double minPanelWidth,
  ) {
    final panels = <Screen>[];
    final sheets = <Screen>[];
    final modals = <Screen>[];

    bool canAddPanel(Screen screen) {
      if (!panels.iterator.moveNext()) {
        return true;
      }
      final totalMinWidth = panels.fold<double>(
        0,
        (previousValue, screen) =>
            previousValue + (screen.width?.start ?? minPanelWidth),
      );

      return totalMinWidth + (screen.width?.start ?? minPanelWidth) <=
          size.width.start;
    }

    for (final screen in currentPath.screens) {
      switch (screen.type) {
        case ScreenType.panel:
          if (canAddPanel(screen)) {
            panels.add(screen);
          } else {
            sheets.add(screen);
          }
          break;
        case ScreenType.sheet:
          sheets.add(screen);
          break;
        case ScreenType.modal:
          modals.add(screen);
          break;
      }
    }

    return ScaffoldLayout(
      size: size,
      panels: panels,
      sheets: sheets,
      modals: modals,
    );
  }

  @override
  Widget build(BuildContext context) {
    final minPanelWidth = context.config.scaffold.defaultPanelSize.width.start;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size.fixed(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );
        return builder(
          context,
          _buildLayout(size, minPanelWidth),
        );
      },
    );
  }
}
