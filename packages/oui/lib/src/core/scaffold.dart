import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart'
    show
        AnimatedSwitcher,
        BuildContext,
        Column,
        CrossAxisAlignment,
        Curves,
        EdgeInsets,
        FlexFit,
        Flexible,
        ImageFiltered,
        LayoutBuilder,
        MainAxisAlignment,
        Padding,
        Positioned,
        Row,
        Stack,
        StatelessWidget,
        Transform,
        Widget;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/state.dart';

import '../components/box.dart';
import '../components/screen.dart';
import 'background.dart';
import 'border.dart';
import 'component.dart';
import 'geometry.dart';
import 'routing.dart';

enum RailContainerStyle {
  // The rails on the sides reach the top and bottom of the container.
  fullHeight,

  // The rails on the top and bottom reach the sides of the container.
  fullWidth,
}

class Rail extends StatelessWidget {
  final RectangleSide side;

  const Rail(
    this.side, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Box().borderForSide(
      side.opposite,
      BorderSide.none,
    );
  }
}

class RailedContainer extends StatelessWidget {
  final Widget child;
  final RailContainerStyle style;

  const RailedContainer({
    super.key,
    required this.child,
    this.style = RailContainerStyle.fullHeight,
  });

  @override
  Widget build(BuildContext context) {
    Column addHorizontalRails(Widget content) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Rail(RectangleSide.top),
          Flexible(
            child: content,
          ),
          const Rail(RectangleSide.bottom),
        ],
      );
    }

    Row addVerticalRails(Widget content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Rail(RectangleSide.left),
          Flexible(
            child: content,
          ),
          const Rail(RectangleSide.right),
        ],
      );
    }

    switch (style) {
      case RailContainerStyle.fullHeight:
        return addVerticalRails(
          addHorizontalRails(child),
        );
      case RailContainerStyle.fullWidth:
        return addHorizontalRails(
          addVerticalRails(child),
        );
    }
  }
}

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
        case ScreenDisplayType.panel:
          if (canAddPanel(screen)) {
            panels.add(screen);
          } else {
            sheets.add(screen);
          }
          break;
        case ScreenDisplayType.sheet:
          sheets.add(screen);
          break;
        case ScreenDisplayType.modal:
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
    final minPanelWidth =
        Config.of(context).scaffold.defaultPanelSize.width.start;
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

class ScaffoldPanels extends StatelessWidget {
  final List<Widget> panels;

  const ScaffoldPanels(
    this.panels, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: panels,
    );
  }
}

class Scaffold extends Box {
  final PathMatch currentPath;

  const Scaffold(
    this.currentPath, {
    super.key,
  });

  List<Widget> _buildPanels(
    BuildContext context,
    List<Screen> panels,
  ) {
    return panels
        .expand(
          (screen) => [
            Flexible(
              flex: screen.width?.weight ?? 1,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: screen,
              ),
            ),
            if (screen != panels.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
          ],
        )
        .toList(growable: false);
  }

  Widget _buildScaffold() {
    return ScaffoldLayoutBuilder(
      currentPath: currentPath,
      builder: (context, layout) {
        final main = RailedContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPanels(context, layout.panels),
          ),
        );

        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: layout.sheets.isNotEmpty
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Transform.scale(
                        scale: 0.9,
                        child: main,
                      ),
                    )
                  : main,
            ),
            if (layout.sheets.length > 1)
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: layout.sheets[layout.sheets.length - 2],
                ),
              ),
            if (layout.sheets.isNotEmpty)
              Positioned.fill(
                child: layout.sheets.last,
              ),
          ],
        );
      },
    );
  }

  @override
  ComponentModifiers get modifiers {
    return [
      const StateModifier(State.normal),
      const BackgroundModifier(null),
      ContentProviderModifier(content: [_buildScaffold()]),
    ];
  }
}
