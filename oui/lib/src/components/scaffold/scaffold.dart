import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart'
    show
        AnimatedSwitcher,
        BuildContext,
        Curves,
        EdgeInsets,
        FlexFit,
        Flexible,
        ImageFiltered,
        Padding,
        Positioned,
        Row,
        Stack,
        StatelessWidget,
        Transform,
        Widget;

import '../../core/colors/color.dart';
import '../../core/geometry/size.dart';
import '../../core/router/path_match.dart';
import '../box/box.dart';
import '../box/modifiers/background.dart';
import '../screen/screen.dart';
import 'rail.dart';
import 'scaffold_layout.dart';

class ScaffoldDivider extends Box {
  const ScaffoldDivider({
    super.key,
  });

  @override
  Size? get size => Size.fixed(width: 1);

  @override
  Background? get background => const Background.color(Color.fromRGB(0, 0, 0));
}

// class ScaffoldDivider extends StatelessWidget {
//   const ScaffoldDivider({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFF000000),
//       width: 1,
//     );
//   }
// }

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

  List<Widget> buildPanels(
    BuildContext context,
    List<Screen> panels,
  ) {
    return panels
        .expand(
          (screen) => [
            Flexible(
              flex: screen.size.width.weight ?? 1,
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: screen,
              ),
            ),
            if (screen != panels.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ScaffoldDivider(),
              ),
          ],
        )
        .toList(growable: false);
  }

  @override
  Widget? get child {
    return ScaffoldLayoutBuilder(
      currentPath: currentPath,
      builder: (context, layout) {
        final main = RailedContainer(
          child: Row(
            children: buildPanels(context, layout.panels),
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
}
