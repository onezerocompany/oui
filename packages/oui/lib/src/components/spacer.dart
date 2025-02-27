import 'package:flutter/widgets.dart' show SizedBox, Widget;

import '../core/component.dart'
    show Component, ComponentContext, ComponentModifiers;

class Spacer extends Component<Spacer> {
  final double? height;
  final double? width;

  const Spacer({
    super.key,
    super.modifiers,
    this.height,
    this.width,
  });

  @override
  Widget builder(ComponentContext context) {
    return SizedBox(
      height: height ?? 8,
      width: width ?? 8,
    );
  }

  @override
  Spacer copyWith({
    ComponentModifiers? modifiers,
    double? height,
    double? width,
  }) {
    return Spacer(
      key: key,
      modifiers: modifiers ?? this.modifiers,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }

  Spacer space(double size) {
    return copyWith(height: size, width: size);
  }

  Spacer vertical(double height) {
    return copyWith(height: height);
  }

  Spacer horizontal(double width) {
    return copyWith(width: width);
  }
}
