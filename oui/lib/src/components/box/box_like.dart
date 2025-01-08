import 'package:flutter/widgets.dart' show Widget, BuildContext;
import 'package:oui/oui.dart';

abstract class BoxLike<T extends Modifiable<T>> extends Modifiable<T>
    with
        ModifiableSize<T>,
        ModifiableAlignment<T>,
        ModifiableCorner<T>,
        ModifiableBackground<T>,
        ModifiableInset<T>,
        ModifiableBorder<T>,
        ModifiableShadow<T> {
  final Widget? content;

  const BoxLike({
    super.key,
    this.content,
    super.modifiers,
  });

  @override
  Widget build(BuildContext context) {
    var widget = buildWithModifiers(
      content,
      ModifierContext(
        runtimeType,
        context,
        context.boxColors.normal,
      ),
    );

    final hasBackground = modifiers.whereType<BackgroundModifier>().isNotEmpty;
    if (hasBackground) {
      return BoxLevel(
        level: context.boxLevel + 1,
        child: widget,
      );
    }
    return widget;
  }
}
