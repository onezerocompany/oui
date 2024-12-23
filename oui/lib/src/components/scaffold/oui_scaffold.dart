import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/router/oui_path_match.dart';
import '../screen/oui_screen.dart';
import 'oui_rail.dart';
import 'oui_scaffold_layout.dart';

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

class OuiScaffoldPanels extends StatelessWidget {
  final List<Widget> panels;

  const OuiScaffoldPanels(
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

class OuiScaffold extends HookConsumerWidget {
  final OuiPathMatch currentPath;

  const OuiScaffold(
    this.currentPath, {
    super.key,
  });

  List<Widget> buildPanels(
    BuildContext context,
    List<OuiScreen> panels,
  ) {
    return panels
        .expand(
          (screen) => [
            Flexible(
              flex: screen.size.width.weight,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: screen,
              ),
            ),
            if (screen != panels.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: OuiScaffoldDivider(),
              ),
          ],
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OuiScaffoldLayoutBuilder(
      currentPath: currentPath,
      builder: (context, layout) {
        final main = OuiRailedContainer(
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
