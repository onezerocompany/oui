import 'package:oui/src/components/box/box_modifier.dart';

import '../../../core/geometry/size.dart';

class BoxSize extends BoxModifier {
  final Size size;
  const BoxSize(this.size);

  @override
  void modify(BoxModifierContext context) {
    // Do not modify here, this modifier is applied in the Box widget
  }
}
