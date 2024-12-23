import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

class OuiScaffoldLayout {
  final Size size;
  final List<OuiScreen> panels;
  final List<OuiScreen> sheets;
  final List<OuiScreen> modals;

  OuiScaffoldLayout({
    required this.size,
    required this.panels,
    required this.sheets,
    required this.modals,
  });
}

class OuiScaffoldLayoutBuilder extends StatelessWidget {
  final OuiPathMatch currentPath;
  final Function(BuildContext context, OuiScaffoldLayout layout) builder;

  const OuiScaffoldLayoutBuilder({
    required this.currentPath,
    required this.builder,
    super.key,
  });

  OuiScaffoldLayout _buildLayout(
    Size size,
  ) {
    final panels = <OuiScreen>[];
    final sheets = <OuiScreen>[];
    final modals = <OuiScreen>[];

    bool canAddPanel(OuiScreen screen) {
      if (panels.isEmpty) {
        return true;
      }
      final totalMinWidth = panels.fold<double>(
        0,
        (previousValue, screen) => previousValue + screen.size.width.minimum,
      );

      return totalMinWidth + screen.size.width.minimum <= size.width;
    }

    for (final screen in currentPath.screens) {
      switch (screen.type) {
        case OuiScreenType.panel:
          if (canAddPanel(screen)) {
            panels.add(screen);
          } else {
            sheets.add(screen);
          }
          break;
        case OuiScreenType.sheet:
          sheets.add(screen);
          break;
        case OuiScreenType.modal:
          modals.add(screen);
          break;
      }
    }

    return OuiScaffoldLayout(
      size: size,
      panels: panels,
      sheets: sheets,
      modals: modals,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return builder(
          context,
          _buildLayout(size),
        );
      },
    );
  }
}
