import 'package:flutter/widgets.dart' as ui
    show
        TextStyle,
        TextAlign,
        TextScaler,
        Text,
        TextOverflow,
        TextWidthBasis,
        TextHeightBehavior,
        Color,
        FontWeight,
        FontVariation;
import 'package:oui/src/core/typography.dart';

import 'colors.dart';
import 'component.dart';

mixin TextStyleModifier on ComponentModifier {
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  );
}

mixin LabelModifier on ComponentModifier {
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  );
}

enum TextAlign {
  start,
  end,
  center,
  justify;

  ui.TextAlign get uiAlign {
    switch (this) {
      case TextAlign.start:
        return ui.TextAlign.start;
      case TextAlign.end:
        return ui.TextAlign.end;
      case TextAlign.center:
        return ui.TextAlign.center;
      case TextAlign.justify:
        return ui.TextAlign.justify;
    }
  }
}

class TextAlignModifier extends ComponentModifier with LabelModifier {
  final TextAlign align;

  const TextAlignModifier(this.align);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      textAlign: align.uiAlign,
    );
  }
}

mixin ModifiableTextAlign<Type extends Component> on Component<Type> {
  Type align(TextAlign align) {
    return withModifier(
      TextAlignModifier(align),
    );
  }

  Type get start => align(TextAlign.start);
  Type get end => align(TextAlign.end);
  Type get center => align(TextAlign.center);
  Type get justify => align(TextAlign.justify);
}

class MaxLinesModifier extends ComponentModifier with LabelModifier {
  final int maxLines;

  const MaxLinesModifier(this.maxLines);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      maxLines: maxLines,
    );
  }
}

mixin ModifiableMaxLines<Type extends Component> on Component<Type> {
  Type lines(int maxLines) {
    return withModifier(
      MaxLinesModifier(maxLines),
    );
  }
}

class SoftWrapModifier extends ComponentModifier with LabelModifier {
  final bool softWrap;

  const SoftWrapModifier(this.softWrap);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      softWrap: softWrap,
    );
  }
}

mixin ModifiableSoftWrap<Type extends Component> on Component<Type> {
  Type wrap(bool softWrap) {
    return withModifier(
      SoftWrapModifier(softWrap),
    );
  }
}

enum TextOverflow {
  clip,
  fade,
  ellipsis,
  visible;

  ui.TextOverflow get uiOverflow {
    switch (this) {
      case TextOverflow.clip:
        return ui.TextOverflow.clip;
      case TextOverflow.fade:
        return ui.TextOverflow.fade;
      case TextOverflow.ellipsis:
        return ui.TextOverflow.ellipsis;
      case TextOverflow.visible:
        return ui.TextOverflow.visible;
    }
  }
}

class TextOverflowModifier extends ComponentModifier with LabelModifier {
  final TextOverflow overflow;

  const TextOverflowModifier(this.overflow);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      overflow: overflow.uiOverflow,
    );
  }
}

mixin ModifiableTextOverflow<Type extends Component> on Component<Type> {
  Type overflow(TextOverflow overflow) {
    return withModifier(
      TextOverflowModifier(overflow),
    );
  }

  Type get clip => overflow(TextOverflow.clip);
  Type get fade => overflow(TextOverflow.fade);
  Type get ellipsis => overflow(TextOverflow.ellipsis);
  Type get visible => overflow(TextOverflow.visible);
}

class TextScalerModifier extends ComponentModifier with LabelModifier {
  final ui.TextScaler scaler;

  const TextScalerModifier(this.scaler);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      textScaler: scaler,
    );
  }
}

mixin ModifiableTextScaler<Type extends Component> on Component<Type> {
  Type scale(ui.TextScaler scaler) {
    return withModifier(
      TextScalerModifier(scaler),
    );
  }
}

enum TextWidthMode {
  longestLine,
  fill;

  ui.TextWidthBasis get basis {
    switch (this) {
      case TextWidthMode.longestLine:
        return ui.TextWidthBasis.longestLine;
      case TextWidthMode.fill:
        return ui.TextWidthBasis.parent;
    }
  }
}

class TextWidthModeModifier extends ComponentModifier with LabelModifier {
  final TextWidthMode mode;

  const TextWidthModeModifier(this.mode);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      textWidthBasis: mode.basis,
    );
  }
}

mixin ModifiableTextWidthMode<Type extends Component> on Component<Type> {
  Type width(TextWidthMode mode) {
    return withModifier(
      TextWidthModeModifier(mode),
    );
  }

  Type get longestLine => width(TextWidthMode.longestLine);
  Type get fill => width(TextWidthMode.fill);
}

class TextHeightBehaviorModifier extends ComponentModifier with LabelModifier {
  final ui.TextHeightBehavior behavior;

  const TextHeightBehaviorModifier(this.behavior);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      textHeightBehavior: behavior,
    );
  }
}

mixin ModifiableTextHeightBehavior<Type extends Component> on Component<Type> {
  Type height(ui.TextHeightBehavior behavior) {
    return withModifier(
      TextHeightBehaviorModifier(behavior),
    );
  }
}

class SemanticsLabelModifier extends ComponentModifier with LabelModifier {
  final String label;

  const SemanticsLabelModifier(this.label);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      semanticsLabel: label,
    );
  }
}

mixin ModifiableSemanticsLabel<Type extends Component> on Component<Type> {
  Type semanticLabel(String label) {
    return withModifier(
      SemanticsLabelModifier(label),
    );
  }
}

class SelectionColorModifier extends ComponentModifier with LabelModifier {
  final Color color;

  const SelectionColorModifier(this.color);

  @override
  ui.Text modify(
    ui.Text text,
    ComponentContext context,
  ) {
    return text.copyWith(
      selectionColor: color.uiColor,
    );
  }
}

class TextColorModifier extends ComponentModifier with TextStyleModifier {
  final Color color;

  const TextColorModifier(this.color);

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      color: color.uiColor,
    );
  }
}

class TextSizeModifier extends ComponentModifier with TextStyleModifier {
  final double size;

  const TextSizeModifier(this.size);

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      fontSize: size,
    );
  }
}

mixin ModifiableTextSize<Type extends Component> on Component<Type> {
  Type size(double size) {
    return withModifier(
      TextSizeModifier(size),
    );
  }
}

class TextWeightModifier extends ComponentModifier with TextStyleModifier {
  final TextWeight weight;

  const TextWeightModifier(this.weight);

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      fontWeight: weight.uiWeight,
      fontVariations: [
        ui.FontVariation.weight(weight.value),
      ],
    );
  }
}

mixin ModifiableTextWeight<Type extends Component> on Component<Type> {
  Type weight(TextWeight weight) {
    return withModifier(
      TextWeightModifier(weight),
    );
  }
}

extension TextExtension on ui.Text {
  ui.Text copyWith({
    ui.TextAlign? textAlign, // done
    ui.TextStyle? style, // todo
    ui.TextScaler? textScaler,
    ui.TextOverflow? overflow,
    ui.TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    String? semanticsLabel,
    int? maxLines,
    bool? softWrap,
    ui.Color? selectionColor,
  }) {
    return ui.Text(
      data ?? "",
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }
}
