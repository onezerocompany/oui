import 'package:flutter/widgets.dart' as ui
    show
        FontStyle,
        FontVariation,
        FontWeight,
        InheritedWidget,
        Text,
        TextAlign,
        TextHeightBehavior,
        TextOverflow,
        TextScaler,
        TextStyle,
        TextWidthBasis;
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:oui/src/core/responsive.dart' show ResponsiveCondition;
import 'package:oui/src/core/utils.dart'
    show EnumContainer, Range, SizeLevel, SizedContainer, TextExtension;

import 'colors.dart' show Color;
import 'component.dart'
    show
        Component,
        ComponentContext,
        ComponentModifier,
        TextModifier,
        TextStyleModifier;
import 'interpolation.dart' show Curve, DoubleInterpolator;

class TypographyConfigGroup {
  final Curve curve;
  final String font;
  final Range<double> size;
  final Range<double> weight;

  const TypographyConfigGroup({
    this.curve = Curve.linear,
    this.font = "NotoSans Regular",
    this.size = const Range(14.0, 28.0),
    this.weight = const Range(300.0, 500.0),
  });
}

class TypographyConfig {
  final TypographyConfigGroup headings;
  final TypographyConfigGroup subheadings;
  final TypographyConfigGroup body;
  final TypographyConfigGroup caption;
  final TypographyConfigGroup footnotes;

  const TypographyConfig({
    this.headings = const TypographyConfigGroup(
      size: Range(18.0, 36.0),
      weight: Range(400.0, 600.0),
    ),
    this.subheadings = const TypographyConfigGroup(
      size: Range(18.0, 36.0),
      weight: Range(400.0, 600.0),
    ),
    this.body = const TypographyConfigGroup(
      size: Range(14.0, 28.0),
      weight: Range(300.0, 500.0),
    ),
    this.caption = const TypographyConfigGroup(
      size: Range(12.0, 24.0),
      weight: Range(300.0, 400.0),
    ),
    this.footnotes = const TypographyConfigGroup(
      size: Range(10.0, 20.0),
      weight: Range(300.0, 400.0),
    ),
  });
}

enum TypographyGroup {
  headings,
  subheadings,
  body,
  caption,
  footnotes,
}

class Typography
    extends EnumContainer<TypographyGroup, TypographyGroupContainer> {
  Typography(super.values);

  factory Typography.fromConfig(TypographyConfig config) {
    return Typography(
      {
        TypographyGroup.headings:
            TypographyGroupContainer.fromConfig(config.headings),
        TypographyGroup.subheadings:
            TypographyGroupContainer.fromConfig(config.subheadings),
        TypographyGroup.body: TypographyGroupContainer.fromConfig(config.body),
        TypographyGroup.caption:
            TypographyGroupContainer.fromConfig(config.caption),
        TypographyGroup.footnotes:
            TypographyGroupContainer.fromConfig(config.footnotes),
      },
    );
  }

  @override
  List<TypographyGroup> get keys => TypographyGroup.values;
}

class TypographyGroupContainer extends SizedContainer<TextStyle> {
  TypographyGroupContainer(super.values);

  factory TypographyGroupContainer.fromConfig(TypographyConfigGroup config) {
    final interpolator = DoubleInterpolator(curve: config.curve);
    return TypographyGroupContainer(
      SizedContainer<TextStyle>.generate((size) {
        return TextStyle(
          size: interpolator.resolve(
            config.size.start,
            config.size.end,
            size.t,
          ),
          weight: TextWeight(
            interpolator.resolve(
              config.weight.start,
              config.weight.end,
              size.t,
            ),
          ),
        );
      }).values,
    );
  }
}

class TypographyContext extends ui.InheritedWidget {
  final TypographyGroup group;
  final SizeLevel size;

  const TypographyContext({
    super.key,
    required this.group,
    required this.size,
    required super.child,
  });

  static TypographyContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TypographyContext>();
  }

  @override
  bool updateShouldNotify(covariant TypographyContext oldWidget) {
    return group != oldWidget.group || size != oldWidget.size;
  }
}

class TextSlant {
  final double value;

  const TextSlant(this.value);

  ui.FontStyle get uiSlant {
    final int snapped = value.round();
    if (snapped == 1) {
      return ui.FontStyle.italic;
    } else {
      return ui.FontStyle.normal;
    }
  }

  static const normal = TextSlant(0);
  static const italic = TextSlant(1);
}

class TextStyle {
  final double size;
  final TextWeight weight;
  final TextSlant italic;
  final WordSpacing wordSpacing;
  final LetterSpacing letterSpacing;

  const TextStyle({
    this.size = 14,
    this.weight = const TextWeight(400),
    this.italic = TextSlant.normal,
    this.wordSpacing = WordSpacing.normal,
    this.letterSpacing = LetterSpacing.normal,
  });
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

class TextAlignModifier extends ComponentModifier with TextModifier {
  final TextAlign align;

  const TextAlignModifier(
    this.align, {
    required super.condition,
  });

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
  Type align(
    TextAlign align, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextAlignModifier(
        align,
        condition: condition,
      ),
    );
  }

  Type get start => align(TextAlign.start);
  Type get end => align(TextAlign.end);
  Type get center => align(TextAlign.center);
  Type get justify => align(TextAlign.justify);
}

class MaxLinesModifier extends ComponentModifier with TextModifier {
  final int maxLines;

  const MaxLinesModifier(
    this.maxLines, {
    required super.condition,
  });

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
  Type lines(
    int maxLines, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      MaxLinesModifier(
        maxLines,
        condition: condition,
      ),
    );
  }
}

class SoftWrapModifier extends ComponentModifier with TextModifier {
  final bool softWrap;

  const SoftWrapModifier(
    this.softWrap, {
    required super.condition,
  });

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
  Type wrap(
    bool softWrap, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      SoftWrapModifier(
        softWrap,
        condition: condition,
      ),
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

class TextOverflowModifier extends ComponentModifier with TextModifier {
  final TextOverflow overflow;

  const TextOverflowModifier(
    this.overflow, {
    required super.condition,
  });

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
  Type overflow(
    TextOverflow overflow, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextOverflowModifier(
        overflow,
        condition: condition,
      ),
    );
  }

  Type get clip => overflow(TextOverflow.clip);
  Type get fade => overflow(TextOverflow.fade);
  Type get ellipsis => overflow(TextOverflow.ellipsis);
  Type get visible => overflow(TextOverflow.visible);
}

class TextScalerModifier extends ComponentModifier with TextModifier {
  final ui.TextScaler scaler;

  const TextScalerModifier(
    this.scaler, {
    required super.condition,
  });

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
  Type scale(
    ui.TextScaler scaler, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextScalerModifier(
        scaler,
        condition: condition,
      ),
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

class TextWidthModeModifier extends ComponentModifier with TextModifier {
  final TextWidthMode mode;

  const TextWidthModeModifier(
    this.mode, {
    required super.condition,
  });

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
  Type width(
    TextWidthMode mode, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextWidthModeModifier(
        mode,
        condition: condition,
      ),
    );
  }

  Type get longestLine => width(TextWidthMode.longestLine);
  Type get fill => width(TextWidthMode.fill);
}

class TextHeightBehaviorModifier extends ComponentModifier with TextModifier {
  final ui.TextHeightBehavior behavior;

  const TextHeightBehaviorModifier(
    this.behavior, {
    required super.condition,
  });

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
  Type height(
    ui.TextHeightBehavior behavior, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextHeightBehaviorModifier(
        behavior,
        condition: condition,
      ),
    );
  }
}

class SemanticsLabelModifier extends ComponentModifier with TextModifier {
  final String label;

  const SemanticsLabelModifier(
    this.label, {
    required super.condition,
  });

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
  Type semanticLabel(
    String label, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      SemanticsLabelModifier(
        label,
        condition: condition,
      ),
    );
  }
}

class SelectionColorModifier extends ComponentModifier with TextModifier {
  final Color color;

  const SelectionColorModifier(
    this.color, {
    required super.condition,
  });

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

mixin ModifiableSelectionColor<Type extends Component> on Component<Type> {
  Type selectionColor(
    Color color, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      SelectionColorModifier(
        color,
        condition: condition,
      ),
    );
  }
}

class TextColorModifier extends ComponentModifier with TextStyleModifier {
  final Color? color;

  const TextColorModifier(
    this.color, {
    super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    if (color == null) {
      return style.copyWith(
        color: context.colors.content.uiColor,
      );
    }

    return style.copyWith(
      color: color!.uiColor,
    );
  }
}

mixin ModifiableTextColor<Type extends Component> on Component<Type> {
  Type color(
    Color? color, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextColorModifier(
        color,
        condition: condition,
      ),
    );
  }
}

class TextSizeModifier extends ComponentModifier with TextStyleModifier {
  final double size;

  const TextSizeModifier(
    this.size, {
    required super.condition,
  });

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
  Type size(
    double size, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextSizeModifier(
        size,
        condition: condition,
      ),
    );
  }
}

class FontModifier extends ComponentModifier with TextStyleModifier {
  final String? font;

  const FontModifier(
    this.font, {
    super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    final config = context.config.typography;
    final defaultFont = config.body.font;
    return style.copyWith(
      fontFamily: font ?? defaultFont,
    );
  }
}

mixin ModifiableFont<Type extends Component> on Component<Type> {
  Type font(
    String font, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      FontModifier(
        font,
        condition: condition,
      ),
    );
  }
}

class TextWeight {
  final double value;

  const TextWeight(this.value);

  ui.FontWeight get uiWeight {
    // round to the nearest 100
    final int rounded = (value / 100).round() * 100;
    if (rounded <= 100) {
      return ui.FontWeight.w100;
    } else if (rounded >= 900) {
      return ui.FontWeight.w900;
    } else if (rounded == 200) {
      return ui.FontWeight.w200;
    } else if (rounded == 300) {
      return ui.FontWeight.w300;
    } else if (rounded == 400) {
      return ui.FontWeight.w400;
    } else if (rounded == 500) {
      return ui.FontWeight.w500;
    } else if (rounded == 600) {
      return ui.FontWeight.w600;
    } else if (rounded == 700) {
      return ui.FontWeight.w700;
    } else if (rounded == 800) {
      return ui.FontWeight.w800;
    } else {
      return ui.FontWeight.normal;
    }
  }

  static const thin = TextWeight(100);
  static const extraLight = TextWeight(200);
  static const light = TextWeight(300);
  static const regular = TextWeight(400);
  static const medium = TextWeight(500);
  static const semiBold = TextWeight(600);
  static const bold = TextWeight(700);
  static const extraBold = TextWeight(800);
  static const black = TextWeight(900);
}

class TextWeightModifier extends ComponentModifier with TextStyleModifier {
  final TextWeight weight;

  const TextWeightModifier(
    this.weight, {
    required super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      fontWeight: weight.uiWeight,
      fontVariations: [
        if (style.fontVariations != null) ...?style.fontVariations,
        ui.FontVariation.weight(weight.value),
      ],
    );
  }
}

mixin ModifiableTextWeight<Type extends Component> on Component<Type> {
  Type weight(
    TextWeight weight, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextWeightModifier(
        weight,
        condition: condition,
      ),
    );
  }
}

class TextSlantModifier extends ComponentModifier with TextStyleModifier {
  final TextSlant slant;

  const TextSlantModifier(
    this.slant, {
    required super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      fontStyle: slant.uiSlant,
      fontVariations: [
        if (style.fontVariations != null) ...?style.fontVariations,
        ui.FontVariation.slant(slant.value),
      ],
    );
  }
}

mixin ModifiableTextSlant<Type extends Component> on Component<Type> {
  Type slant(
    TextSlant slant, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      TextSlantModifier(
        slant,
        condition: condition,
      ),
    );
  }
}

class LetterSpacing {
  final double value;

  const LetterSpacing(this.value);

  static const tighter = LetterSpacing(-1.0);
  static const tight = LetterSpacing(-0.5);
  static const normal = LetterSpacing(0);
  static const wide = LetterSpacing(0.5);
  static const wider = LetterSpacing(1.0);
  static const widest = LetterSpacing(2.0);
}

class LetterSpacingModifier extends ComponentModifier with TextStyleModifier {
  final LetterSpacing letterSpacing;

  const LetterSpacingModifier(
    this.letterSpacing, {
    required super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      letterSpacing: letterSpacing.value,
    );
  }
}

mixin ModifiableLetterSpacing<Type extends Component> on Component<Type> {
  Type letterSpacing(
    LetterSpacing letterSpacing, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      LetterSpacingModifier(
        letterSpacing,
        condition: condition,
      ),
    );
  }
}

class WordSpacing {
  final double value;

  const WordSpacing(this.value);

  static const tighter = WordSpacing(-1.0);
  static const tight = WordSpacing(-0.5);
  static const normal = WordSpacing(0);
  static const wide = WordSpacing(0.5);
  static const wider = WordSpacing(1.0);
  static const widest = WordSpacing(2.0);
}

class WordSpacingModifier extends ComponentModifier with TextStyleModifier {
  final WordSpacing wordSpacing;

  const WordSpacingModifier(
    this.wordSpacing, {
    required super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    return style.copyWith(
      wordSpacing: wordSpacing.value,
    );
  }
}

mixin ModifiableWordSpacing<Type extends Component> on Component<Type> {
  Type wordSpacing(WordSpacing wordSpacing, {ResponsiveCondition? condition}) {
    return withModifier(
      WordSpacingModifier(
        wordSpacing,
        condition: condition,
      ),
    );
  }
}
