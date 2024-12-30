import 'package:oui/src/core/geometry/size.dart';

class ScaffoldConfig {
  final bool usePanels;
  final Size defaultPanelSize;
  final double defaultRailWidth = 68;

  const ScaffoldConfig({
    this.usePanels = true,
    this.defaultPanelSize = Size.infinite,
  });
}
