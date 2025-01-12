import 'package:flutter/widgets.dart' show Text, Widget;

import '../core/_index.dart';

class Label extends Component<Label> {
  final String text;

  const Label(
    this.text, {
    super.key,
    super.modifiers,
  });

  @override
  Label copyWith({ComponentModifiers? modifiers}) {
    return Label(
      text,
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  Widget buildWithModifiers(
    ComponentContext context, [
    Widget? child,
  ]) {
    final label = Text(text);
    return label;
  }
}
