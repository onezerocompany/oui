import 'package:flutter/widgets.dart' as ui;
import 'package:flutter/widgets.dart' show Text, Widget;
import 'package:oui/src/core/text.dart';

import '../core/_index.dart';

class Label extends Component<Label>
    with
        ModifiableMaxLines<Label>,
        ModifiableTextAlign<Label>,
        ModifiableSoftWrap<Label>,
        ModifiableTextOverflow<Label>,
        ModifiableTextScaler<Label>,
        ModifiableTextWidthMode<Label>,
        ModifiableTextHeightBehavior<Label>,
        ModifiableSemanticsLabel<Label>,
        ModifiableTextSize<Label>,
        ModifiableTextWeight<Label> {
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
    Text label = Text(text);
    ui.TextStyle style = const ui.TextStyle();

    for (final modifier in modifiers) {
      if (modifier is LabelModifier) {
        label = modifier.modify(label, context);
      }
      if (modifier is TextStyleModifier) {
        style = modifier.modify(style, context);
      }
    }

    label = label.copyWith(style: style);

    return label;
  }
}
