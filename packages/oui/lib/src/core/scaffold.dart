import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart'
    show
        AnimatedSwitcher,
        Animation,
        BuildContext,
        Column,
        CrossAxisAlignment,
        Curves,
        EdgeInsets,
        FadeTransition,
        FlexFit,
        Flexible,
        ImageFiltered,
        Key,
        LayoutBuilder,
        MainAxisAlignment,
        Offset,
        Padding,
        Positioned,
        Row,
        SafeArea,
        SlideTransition,
        Stack,
        StatefulWidget,
        StatelessWidget,
        Transform,
        Tween,
        Widget;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:oui/src/core/border.dart' show BorderSide;
import 'package:oui/src/core/component.dart' show ComponentContext;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/geometry.dart'
    show RectangleSide, Size, SizeModifier;
import 'package:oui/src/core/routing.dart' show PathMatch;
import 'package:oui/src/core/screen.dart'
    show Screen, ScreenBox, ScreenDisplayType;
import 'package:oui/src/core/state.dart' show State, StateContext;

import '../components/box.dart' show Box, BoxLevel, BoxLevelContext;

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
  final ScaffoldPanels panels;
  final ScaffoldPanels sheets;
  final ScaffoldPanels modals;

  ScaffoldLayout({
    required this.size,
    required this.panels,
    required this.sheets,
    required this.modals,
  });
}

class ScaffoldLayoutBuilder extends StatelessWidget {
  final Config config;
  final List<ScaffoldPanel> _unsortedPanels;
  final Function(BuildContext context, ScaffoldLayout layout) builder;

  const ScaffoldLayoutBuilder({
    required this.config,
    required this.builder,
    required List<ScaffoldPanel> panels,
    super.key,
  }) : _unsortedPanels = panels;

  ScaffoldLayout _buildLayout(Size size) {
    final panels = <ScaffoldPanel>[];
    final sheets = <ScaffoldPanel>[];
    final modals = <ScaffoldPanel>[];

    bool canAddPanel(ScaffoldPanel panel) {
      if (!panels.iterator.moveNext()) {
        return true;
      }
      final totalMinWidth = panels.fold<double>(
        0,
        (previousValue, screen) => previousValue + panel.size.width.start,
      );
      return totalMinWidth + panel.size.width.start <= size.width.start;
    }

    for (final panel in _unsortedPanels) {
      switch (panel.screen.metadata.type) {
        case ScreenDisplayType.panel:
          if (canAddPanel(panel)) {
            panels.add(panel);
          } else {
            sheets.add(panel);
          }
          break;
        case ScreenDisplayType.sheet:
          sheets.add(panel);
          break;
        case ScreenDisplayType.modal:
          modals.add(panel);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size.fixed(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );
        return builder(
          context,
          _buildLayout(size),
        );
      },
    );
  }
}

// class ScaffoldPanels extends StatelessWidget {
//   final List<Widget> panels;

//   const ScaffoldPanels(
//     this.panels, {
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: panels,
//     );
//   }
// }

class ScaffoldPanel {
  final Screen screen;
  final Size size;

  const ScaffoldPanel(
    this.screen,
    this.size,
  );
}

typedef ScaffoldPanels = List<ScaffoldPanel>;

class Scaffold extends StatefulWidget {
  const Scaffold({
    super.key,
    PathMatch? currentMatch,
    required this.config,
  }) : _currentMatch = currentMatch;

  final PathMatch? _currentMatch;
  final Config config;

  @override
  widgets.State<Scaffold> createState() => _ScaffoldState();
}

class _ScaffoldState extends widgets.State<Scaffold> {
  ScaffoldPanels _panels = [];

  Size _panelSize(Screen screen) {
    final panelModifiers = screen.content(const ScreenBox()).modifiers;
    final sizeModifiers = panelModifiers.whereType<SizeModifier>().where(
          (modifier) => modifier.condition == null,
        );
    return sizeModifiers.first.size ?? widget.config.scaffold.defaultPanelSize;
  }

  ScaffoldPanels _createPanelsFromMatch(PathMatch? match) {
    return match?.screens.map((screen) {
          return ScaffoldPanel(screen, _panelSize(screen));
        }).toList() ??
        [];
  }

  @override
  void initState() {
    super.initState();
    _panels = _createPanelsFromMatch(widget._currentMatch);
  }

  @override
  void didUpdateWidget(covariant Scaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._currentMatch != widget._currentMatch) {
      setState(() {
        _panels = _createPanelsFromMatch(widget._currentMatch);
      });
    }
  }

  List<Widget> _buildPanels(
    BuildContext context,
    ScaffoldPanels panels,
  ) {
    return panels
        .expand(
          (panel) => [
            Flexible(
              flex: panel.size.width.weight,
              fit: FlexFit.loose,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.fastEaseInToSlowEaseOut,
                switchOutCurve: Curves.fastEaseInToSlowEaseOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.01),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  // Using the screen's ID as a key to ensure AnimatedSwitcher
                  // can detect changes and perform animations
                  key: Key(panel.screen.metadata.id),
                  child: panel.screen.content(
                    ScreenBox.base(),
                  ),
                ),
              ),
            ),
            if (panel != panels.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
          ],
        )
        .toList(growable: false);
  }

  Widget _buildScaffold(ComponentContext context) {
    return ScaffoldLayoutBuilder(
      config: context.config,
      panels: _panels,
      builder: (context, layout) {
        final main = SafeArea(
          child: RailedContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPanels(context, layout.panels),
            ),
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
                  child: layout.sheets[layout.sheets.length - 2].screen.content(
                    ScreenBox.base(),
                  ),
                ),
              ),
            if (layout.sheets.isNotEmpty)
              Positioned.fill(
                child: layout.sheets.last.screen.content(
                  ScreenBox.base(),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return StateContext(
      state: State.normal,
      child: BoxLevelContext(
        level: const BoxLevel(0),
        child: const Box().defaultBackground().contentBuilder(_buildScaffold),
      ),
    );
  }
}
