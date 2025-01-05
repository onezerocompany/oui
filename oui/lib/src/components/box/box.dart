import 'package:flutter/widgets.dart' show BuildContext, Widget;

import '../modifiable/modifiable.dart';
import '../modifiable/modifier.dart';
import '../modifiable/modifiers/alignment_modifier.dart';
import '../modifiable/modifiers/background_modifier.dart';
import '../modifiable/modifiers/border_modifier.dart';
import '../modifiable/modifiers/corner_modifier.dart';
import '../modifiable/modifiers/inset_modifier.dart';
import '../modifiable/modifiers/shadow_modifier.dart';
import '../modifiable/modifiers/size_modifier.dart';
import 'box_level.dart';

class Box extends Modifiable<Box>
    with
        ModifiableSize<Box>,
        ModifiableAlignment<Box>,
        ModifiableCorner<Box>,
        ModifiableBackground<Box>,
        ModifiableInset<Box>,
        ModifiableBorder<Box>,
        ModifiableShadow<Box> {
  final Widget? content;

  const Box({
    super.key,
    this.content,
    super.modifiers,
  });

  @override
  Box copyWith({Modifiers? modifiers}) {
    return Box(
      key: key,
      content: content,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = context.boxLevel;
    final hasBackground = modifiers.whereType<BackgroundModifier>().any(
      (background) {
        return background.background?.shouldRender == true;
      },
    );

    return BoxLevel(
      level: level + 1,
      hasBackground: hasBackground,
      child: buildWithModifiers(content, context),
    );
  }
}
