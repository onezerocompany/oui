import 'package:flutter/widgets.dart' show Decoration, Widget;
import 'package:oui/src/components/app/static_app_context.dart';

import '../../../core/colors/color.dart';
import '../../../core/colors/gradient.dart';
import '../../shared/background.dart';
import '../../shared/background_image.dart';
import '../modifiable.dart';
import '../modifier.dart';

class BackgroundModifier extends Modifier
    with ChildModifier, DecorationModifier {
  final Background? background;

  const BackgroundModifier(this.background);

  @override
  Decoration? decorate(
    Decoration decoration,
    ModifierContext context,
  ) {
    if (background == null) {
      final color = context.buildContext.boxColors.normal.surface.normal;
      return Background.color(color).decorate(
        decoration,
        context.buildContext,
      );
    }

    return background?.decorate(
      decoration,
      context.buildContext,
    );
  }

  @override
  Widget? modify(
    Widget child,
    ModifierContext context,
  ) {
    return background?.modify(child, context);
  }
}

mixin ModifiableBackground<Component extends Modifiable>
    on Modifiable<Component> {
  Component background([Background? background]) {
    return withModifier(
      BackgroundModifier(background),
    );
  }

  Component backgroundColor(Color color) {
    return withModifier(
      BackgroundModifier(
        Background.color(color),
      ),
    );
  }

  Component backgroundImage(BackgroundImage image) {
    return withModifier(
      BackgroundModifier(
        Background.image(image),
      ),
    );
  }

  Component backgroundGradient(Gradient gradient) {
    return withModifier(
      BackgroundModifier(
        Background.gradient(gradient),
      ),
    );
  }
}
