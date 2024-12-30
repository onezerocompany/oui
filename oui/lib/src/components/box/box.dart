import 'package:flutter/widgets.dart'
    show BoxDecoration, BuildContext, DecoratedBox, SizedBox, Widget;

import '../../core/geometry/size.dart';
import '../shared/modifiable_component.dart';
import 'box_modifier.dart';
import 'modifiers/alignment.dart';
import 'modifiers/background.dart';
import 'modifiers/border.dart';
import 'modifiers/box_size.dart';
import 'modifiers/corners.dart';
import 'modifiers/insets.dart';
import 'modifiers/shadow.dart';

/// A custom box widget that allows for extensive styling options.
///
/// The [Box] widget provides a flexible container with various styling
/// options such as background, corner radius, shadow, border, padding, and
/// alignment. It can be used to create complex UI elements with ease.
class Box extends ModifiableComponent<BoxModifier, BoxModifierContext> {
  /// The child widget to be displayed inside the box.
  final Widget? content;

  /// Creates a new [Box] widget.
  ///
  /// All parameters are optional and can be used to customize the appearance
  /// of the box.
  const Box({
    super.key,
    this.content,
  }) : super(modifiers: const []);

  const Box._({
    super.key,
    this.content,
    required super.modifiers,
  });

  Size? get currentSize => modifiers.whereType<BoxSize>().lastOrNull?.size;

  const Box.withModifiers(
    BoxModifiers modifiers, {
    super.key,
    this.content,
  }) : super(modifiers: modifiers);

  @override
  BoxModifierContext createContext(BuildContext context) {
    return BoxModifierContext(
      context: context,
      modifiers: modifiers,
      content: content ?? const SizedBox.shrink(),
      decoration: const BoxDecoration(),
    );
  }

  @override
  Widget buildWithContext(BoxModifierContext context) {
    Widget box = context.content;

    if (context.didDecorate) {
      box = DecoratedBox(decoration: context.decoration, child: box);
    }

    final size = modifiers.whereType<BoxSize>().lastOrNull?.size;
    if (size != null && size.shouldRender == true) {
      box = size.apply(box);
    }

    return box;
  }

  @override
  ModifiableComponent<BoxModifier, BoxModifierContext> copyWith({
    List<BoxModifier>? modifiers,
  }) {
    return Box._(
      key: key,
      content: content,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  Box background(Background background) => withModifier(background) as Box;
  Box size(BoxSize size) => withModifier(size) as Box;
  Box alignment(Alignment alignment) => withModifier(alignment) as Box;
  Box insets(Insets insets) => withModifier(insets) as Box;
  Box corners(Corners corners) => withModifier(corners) as Box;
  Box shadow(Shadow shadow) => withModifier(shadow) as Box;
  Box border(Border border) => withModifier(border) as Box;
}
