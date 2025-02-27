import 'package:flutter/widgets.dart' show Key, Text, TextStyle, Widget;
import 'package:oui/src/core/colors.dart' show ModifiableAccent;
import 'package:oui/src/core/component.dart'
    show Component, ComponentContext, ComponentModifier, ComponentModifiers;
import 'package:oui/src/core/localization.dart'
    show Localized, LocalizedExtension;
import 'package:oui/src/core/state.dart' show ModifiableState;
import 'package:oui/src/core/utils.dart'
    show FirstOfTypeExtension, TextExtension;

import '../core/typography.dart'
    show
        FontModifier,
        ModifiableLetterSpacing,
        ModifiableMaxLines,
        ModifiableSelectionColor,
        ModifiableSemanticsLabel,
        ModifiableSoftWrap,
        ModifiableTextAlign,
        ModifiableTextColor,
        ModifiableTextHeightBehavior,
        ModifiableTextOverflow,
        ModifiableTextScaler,
        ModifiableTextSize,
        ModifiableTextSlant,
        ModifiableTextWeight,
        ModifiableTextWidthMode,
        ModifiableTypography,
        ModifiableWordSpacing,
        TextColorModifier,
        TypographyContext,
        TypographyModifier;

/// Mixin for modifiers that modify text styles.
mixin TextStyleModifier on ComponentModifier {
  TextStyle modify(
    TextStyle style,
    ComponentContext context,
  );
}

/// Mixin for modifiers that modify labels.
mixin TextModifier on ComponentModifier {
  Text modify(
    Text text,
    ComponentContext context,
  );
}

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
        ModifiableState<Label>,
        ModifiableTypography<Label> {
  const Label._({
    this.text,
    this.localized,
    super.key,
    ComponentModifiers? modifiers,
  }) : super(
          modifiers: modifiers ??
              const [
                FontModifier(),
                TextColorModifier(),
              ],
        );

  final String? text;
  final Localized<String>? localized;

  factory Label.text(
    String text, {
    Key? key,
    ComponentModifiers? modifiers,
  }) {
    return Label._(
      text: text,
      key: key,
      modifiers: modifiers,
    );
  }

  factory Label.localized(
    Localized<String> localized, {
    Key? key,
    ComponentModifiers? modifiers,
  }) {
    return Label._(
      localized: localized,
      key: key,
      modifiers: modifiers,
    );
  }

  @override
  Label copyWith({ComponentModifiers? modifiers}) {
    return Label._(
      text: text,
      localized: localized,
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  Widget builder(ComponentContext context) {
    var label = Text(localized?.resolve(context.build) ?? text ?? '');

    final labelModifiers = context.modifiers.whereType<TextModifier>();
    label = labelModifiers.fold(label, (Text acc, modifier) {
      return modifier.modify(acc, context);
    });

    final typographyModifier =
        context.modifiers.firstOfType<TypographyModifier>();
    final styleModifiers = context.modifiers.whereType<TextStyleModifier>();
    TextStyle style = typographyModifier?.context.style(context) ??
        TypographyContext.of(context.build)?.style(context) ??
        const TextStyle();
    style = styleModifiers.fold(style, (TextStyle acc, modifier) {
      return modifier.modify(acc, context);
    });

    label = label.copyWith(style: style);

    return label;
  }
}

typedef LabelBuilder = Label Function(ComponentContext context);
