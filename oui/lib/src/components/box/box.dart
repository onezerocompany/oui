import 'package:oui/oui.dart';
import 'package:oui/src/components/box/box_like.dart';

class Box extends BoxLike<Box> {
  const Box({
    super.key,
    super.modifiers,
    super.content,
  });

  @override
  Box copyWith({Modifiers? modifiers}) {
    return Box(
      key: key,
      content: content,
      modifiers: modifiers ?? this.modifiers,
    );
  }
}
