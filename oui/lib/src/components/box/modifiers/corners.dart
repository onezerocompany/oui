import 'package:oui/src/components/box/box_modifier.dart';
import 'package:oui/src/components/corners/corner_border_radius.dart';

class Corners extends BoxModifier {
  final CornerBorderRadius corner;

  const Corners(this.corner);

  @override
  void modify(BoxModifierContext context) {
    context.decorate(
      context.decoration.copyWith(
        borderRadius: corner,
      ),
    );
  }
}
