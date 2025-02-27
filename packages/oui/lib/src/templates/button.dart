import 'package:flutter/widgets.dart' show Key;
import 'package:oui/oui.dart';

enum ButtonStyle {
  action,
  simple,
  chip,
}

class ButtonTemplate extends Template {
  final ButtonStyle style;
  final Label? label;
  final LabelBuilder? labelBuilder;

  const ButtonTemplate({
    this.style = ButtonStyle.simple,
    this.label,
    this.labelBuilder,
  });

  SizeLevel get labelSize {
    switch (style) {
      case ButtonStyle.simple:
        return SizeLevel.medium;
      case ButtonStyle.action:
        return SizeLevel.large;
      case ButtonStyle.chip:
        return SizeLevel.small;
    }
  }

  Label styledLabel(Label label) {
    var styled = label;

    if ([ButtonStyle.action].contains(style)) {
      styled = styled.defaultColor(flipped: true);
    }

    return styled.typography(TypographyGroup.button, labelSize);
  }

  Insets get insets {
    switch (style) {
      case ButtonStyle.simple:
        return const Insets.symmetric(horizontal: 16, vertical: 8);
      case ButtonStyle.action:
        return const Insets.symmetric(horizontal: 32, vertical: 16);
      case ButtonStyle.chip:
        return const Insets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  Box styledBox(Box box) {
    Box styled = box;

    // add default flipped background
    if ([ButtonStyle.action].contains(style)) {
      styled = styled
          .defaultBackground(flipped: true)
          .rounded(size: SizeLevel.medium);
    }

    // add insets
    styled = styled.inset(insets);

    return styled;
  }

  @override
  Component build(ComponentContext context) {
    Label? label = labelBuilder?.call(context) ?? this.label;
    if (label != null && labelBuilder == null) {
      label = styledLabel(label);
    }
    return styledBox(
      const Box().contents(
        [
          if (label != null) label,
        ],
        direction: FlowDirection.leftToRight,
      ),
    );
  }

  @override
  ButtonTemplate copyWith({
    ButtonStyle? style,
    Label? label,
    LabelBuilder? labelBuilder,
  }) {
    return ButtonTemplate(
      style: style ?? this.style,
      label: label ?? this.label,
      labelBuilder: labelBuilder ?? this.labelBuilder,
    );
  }
}

class Button extends TemplateComponent<ButtonTemplate> {
  const Button({
    super.key,
    super.modifiers,
    super.template = const ButtonTemplate(),
  });

  @override
  Button copyWith({
    Key? key,
    ComponentModifiers? modifiers,
    ButtonTemplate? template,
  }) {
    return Button(
      key: key ?? this.key,
      modifiers: modifiers ?? this.modifiers,
      template: template ?? this.template,
    );
  }

  Button style(ButtonStyle style) {
    return copyWith(
      template: template.copyWith(
        style: style,
      ),
    );
  }

  Button localized(Localized<String> label) {
    return copyWith(
      template: template.copyWith(
        label: Label.localized(label),
      ),
    );
  }

  Button label(String label) {
    return copyWith(
      template: template.copyWith(
        label: Label.text(label),
      ),
    );
  }

  Button labelBuilder(LabelBuilder labelBuilder) {
    return copyWith(
      template: template.copyWith(
        labelBuilder: labelBuilder,
      ),
    );
  }
}
