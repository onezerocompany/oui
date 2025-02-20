import 'package:flutter/widgets.dart' as ui;
import 'package:flutter/widgets.dart' show Key, Text, Widget;

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
        ModifiableTextWeight<Label>,
        ModifiableTextSlant<Label>,
        ModifiableTextColor<Label>,
        ModifiableSelectionColor<Label>,
        ModifiableLetterSpacing<Label>,
        ModifiableWordSpacing<Label>,
        ModifiableAccent<Label>,
        ModifiableState<Label> {
  const Label(
    this.text, {
    this.localized,
    super.key,
    ComponentModifiers? modifiers,
  }) : super(
          modifiers: modifiers ??
              const [
                FontModifier(null),
                TextColorModifier(null),
              ],
        );

  final String? text;
  final Localized<String>? localized;

  factory Label.localized(
    Localized<String> localized, {
    Key? key,
    ComponentModifiers? modifiers,
  }) {
    return Label(
      null,
      localized: localized,
      key: key,
      modifiers: modifiers,
    );
  }

  @override
  Label copyWith({ComponentModifiers? modifiers}) {
    return Label(
      text,
      localized: localized,
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  Widget _buildWithModifiers(
    ComponentContext context, [
    Widget? child,
  ]) {
    Text label = Text(text ?? '', maxLines: 1);
    ui.TextStyle style = const ui.TextStyle();

    for (final modifier in context.modifiers) {
      if (modifier is TextModifier) {
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
