import 'package:flutter/widgets.dart' show BoxDecoration, Widget;

import '../shared/modifiable_component.dart';

class BoxModifierContext extends ComponentModifierContext {
  bool didDecorate;
  bool didModifyContent;
  Widget content;
  BoxDecoration decoration;

  BoxModifierContext({
    this.didDecorate = false,
    this.didModifyContent = false,
    required super.context,
    required super.modifiers,
    required this.content,
    required this.decoration,
  });

  void modifyContent(Widget content) {
    this.content = content;
    didModifyContent = true;
    didModify = true;
  }

  void decorate(BoxDecoration decoration) {
    this.decoration = decoration;
    didDecorate = true;
    didModify = true;
  }
}

abstract class BoxModifier extends ComponentModifier<BoxModifierContext> {
  const BoxModifier();

  /// Modifies the content of the box.
  /// Returns `true` if the content was modified, `false` otherwise.
  @override
  void modify(BoxModifierContext context);
}

typedef BoxModifiers = List<BoxModifier>;
