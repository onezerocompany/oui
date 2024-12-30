import 'package:flutter/widgets.dart';
import 'package:oui/src/core/colors/palette/color_palette.dart';

class DynamicAppContext extends InheritedWidget {
  final ColorPalette colorPalette;

  const DynamicAppContext({
    super.key,
    required this.colorPalette,
    required super.child,
  });

  static DynamicAppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamicAppContext>();
  }

  static ColorPalette? colorPaletteOf(BuildContext context) {
    return of(context)?.colorPalette;
  }

  @override
  bool updateShouldNotify(DynamicAppContext oldWidget) {
    return colorPalette != oldWidget.colorPalette;
  }
}
