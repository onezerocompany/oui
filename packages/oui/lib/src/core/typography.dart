import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, Widget;
import 'package:flutter/widgets.dart' as ui
    show
        FontStyle,
        FontVariation,
        FontWeight,
        Text,
        TextAlign,
        TextHeightBehavior,
        TextOverflow,
        TextScaler,
        TextStyle,
        TextWidthBasis;

import '../components/label.dart' show TextModifier, TextStyleModifier;
import 'colors.dart' show Color;
import 'component.dart'
    show Component, ComponentContext, ComponentModifier, WrapperModifier;
import 'context.dart' show ContextCondition;
import 'interpolation.dart' show Curve, DoubleInterpolator;
import 'utils.dart'
    show EnumContainer, Range, SizeLevel, SizedContainer, TextExtension;

class TypographyConfigGroup {
  final Curve curve;
  final String font;
  final Range<double> size;
  final Range<double> weight;

  const TypographyConfigGroup({
    required this.curve,
    required this.font,
    required this.size,
    required this.weight,
  });

  const TypographyConfigGroup.headings({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(18.0, 64.0),
    this.weight = const Range(400.0, 600.0),
  });

  const TypographyConfigGroup.subheadings({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(18.0, 34.0),
    this.weight = const Range(400.0, 600.0),
  });

  const TypographyConfigGroup.body({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(8.0, 28.0),
    this.weight = const Range(300.0, 500.0),
  });

  const TypographyConfigGroup.caption({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(12.0, 24.0),
    this.weight = const Range(300.0, 400.0),
  });

  const TypographyConfigGroup.footnotes({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(10.0, 20.0),
    this.weight = const Range(300.0, 400.0),
  });

  const TypographyConfigGroup.button({
    this.curve = Curve.linear,
    this.font = "Roboto",
    this.size = const Range(12.0, 24.0),
    this.weight = const Range(400.0, 600.0),
  });
}

class TypographyConfig {
  final TypographyConfigGroup headings;
  final TypographyConfigGroup subheadings;
  final TypographyConfigGroup body;
  final TypographyConfigGroup caption;
  final TypographyConfigGroup footnotes;
  final TypographyConfigGroup button;

  const TypographyConfig({
    this.headings = const TypographyConfigGroup.headings(),
    this.subheadings = const TypographyConfigGroup.subheadings(),
    this.body = const TypographyConfigGroup.body(),
    this.caption = const TypographyConfigGroup.caption(),
    this.footnotes = const TypographyConfigGroup.footnotes(),
    this.button = const TypographyConfigGroup.body(),
  });

  static TypographyConfig withFont(String font) {
    return TypographyConfig(
      headings: TypographyConfigGroup.headings(font: font),
      subheadings: TypographyConfigGroup.subheadings(font: font),
      body: TypographyConfigGroup.body(font: font),
      caption: TypographyConfigGroup.caption(font: font),
      footnotes: TypographyConfigGroup.footnotes(font: font),
      button: TypographyConfigGroup.button(font: font),
    );
  }
}

enum TypographyGroup {
  headings,
  subheadings,
  body,
  caption,
  footnotes,
  button,
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
        TypographyGroup.button:
            TypographyGroupContainer.fromConfig(config.button),
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

class TypographyContext {
  final TypographyGroup group;
  final SizeLevel size;

  const TypographyContext({
    required this.group,
    required this.size,
  });

  static TypographyContext? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TypographyContextProvider>()
        ?.context;
  }

  ui.TextStyle style(ComponentContext context) {
    return context.typography.get(group).get(size).uiStyle;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypographyContext &&
        other.group == group &&
        other.size == size;
  }

  @override
  int get hashCode => group.hashCode ^ size.hashCode;
}

class TypographyContextProvider extends InheritedWidget {
  final TypographyContext context;

  const TypographyContextProvider({
    super.key,
    required this.context,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant TypographyContextProvider oldWidget) {
    return context != oldWidget.context;
  }
}

class TypographyModifier extends ComponentModifier with WrapperModifier {
  final TypographyContext context;

  const TypographyModifier({
    required this.context,
    super.condition,
  });

  @override
  Widget wrap(
    Widget child,
    ComponentContext componentContext,
  ) {
    return TypographyContextProvider(
      context: context,
      child: child,
    );
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TypographyModifier) {
      return TypographyModifier(
        context: context,
      );
    }
    return this;
  }
}

mixin ModifiableTypography<Type extends Component> on Component<Type> {
  Type typography(
    TypographyGroup group,
    SizeLevel size, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TypographyModifier(
        context: TypographyContext(group: group, size: size),
        condition: condition,
      ),
    );
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

  ui.TextStyle get uiStyle {
    return ui.TextStyle(
      fontSize: size,
      fontWeight: weight.uiWeight,
      fontStyle: italic.uiSlant,
      letterSpacing: letterSpacing.value,
      wordSpacing: wordSpacing.value,
    );
  }
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

  const TextAlignModifier({
    required this.align,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextAlignModifier) {
      return TextAlignModifier(
        align: other.align,
      );
    }
    return this;
  }
}

mixin ModifiableTextAlign<Type extends Component> on Component<Type> {
  Type align(
    TextAlign align, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextAlignModifier(
        align: align,
        condition: condition,
      ),
    );
  }
}

class MaxLinesModifier extends ComponentModifier with TextModifier {
  final int maxLines;

  const MaxLinesModifier({
    required this.maxLines,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is MaxLinesModifier) {
      return MaxLinesModifier(
        maxLines: other.maxLines,
      );
    }
    return this;
  }
}

mixin ModifiableMaxLines<Type extends Component> on Component<Type> {
  Type lines(
    int maxLines, {
    ContextCondition? condition,
  }) {
    return withModifier(
      MaxLinesModifier(
        maxLines: maxLines,
        condition: condition,
      ),
    );
  }
}

class SoftWrapModifier extends ComponentModifier with TextModifier {
  final bool softWrap;

  const SoftWrapModifier({
    required this.softWrap,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is SoftWrapModifier) {
      return SoftWrapModifier(
        softWrap: other.softWrap,
      );
    }
    return this;
  }
}

mixin ModifiableSoftWrap<Type extends Component> on Component<Type> {
  Type wrap(
    bool softWrap, {
    ContextCondition? condition,
  }) {
    return withModifier(
      SoftWrapModifier(
        softWrap: softWrap,
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

  const TextOverflowModifier({
    required this.overflow,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextOverflowModifier) {
      return TextOverflowModifier(
        overflow: other.overflow,
      );
    }
    return this;
  }
}

mixin ModifiableTextOverflow<Type extends Component> on Component<Type> {
  Type overflow(
    TextOverflow overflow, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextOverflowModifier(
        overflow: overflow,
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

  const TextScalerModifier({
    required this.scaler,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextScalerModifier) {
      return TextScalerModifier(
        scaler: other.scaler,
      );
    }
    return this;
  }
}

mixin ModifiableTextScaler<Type extends Component> on Component<Type> {
  Type scale(
    ui.TextScaler scaler, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextScalerModifier(
        scaler: scaler,
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

  const TextWidthModeModifier({
    required this.mode,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextWidthModeModifier) {
      return TextWidthModeModifier(mode: mode);
    }
    return this;
  }
}

mixin ModifiableTextWidthMode<Type extends Component> on Component<Type> {
  Type width(
    TextWidthMode mode, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextWidthModeModifier(
        mode: mode,
        condition: condition,
      ),
    );
  }

  Type get longestLine => width(TextWidthMode.longestLine);
  Type get fill => width(TextWidthMode.fill);
}

class TextHeightBehaviorModifier extends ComponentModifier with TextModifier {
  final ui.TextHeightBehavior behavior;

  const TextHeightBehaviorModifier({
    required this.behavior,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextHeightBehaviorModifier) {
      return TextHeightBehaviorModifier(
        behavior: other.behavior,
      );
    }
    return this;
  }
}

mixin ModifiableTextHeightBehavior<Type extends Component> on Component<Type> {
  Type height(
    ui.TextHeightBehavior behavior, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextHeightBehaviorModifier(
        behavior: behavior,
        condition: condition,
      ),
    );
  }
}

class SemanticsLabelModifier extends ComponentModifier with TextModifier {
  final String label;

  const SemanticsLabelModifier({
    required this.label,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is SemanticsLabelModifier) {
      return SemanticsLabelModifier(
        label: other.label,
      );
    }
    return this;
  }
}

mixin ModifiableSemanticsLabel<Type extends Component> on Component<Type> {
  Type semanticLabel(
    String label, {
    ContextCondition? condition,
  }) {
    return withModifier(
      SemanticsLabelModifier(
        label: label,
        condition: condition,
      ),
    );
  }
}

class SelectionColorModifier extends ComponentModifier with TextModifier {
  final Color color;

  const SelectionColorModifier({
    required this.color,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is SelectionColorModifier) {
      return SelectionColorModifier(
        color: other.color,
      );
    }
    return this;
  }
}

mixin ModifiableSelectionColor<Type extends Component> on Component<Type> {
  Type selectionColor({
    required Color color,
    ContextCondition? condition,
  }) {
    return withModifier(
      SelectionColorModifier(
        color: color,
        condition: condition,
      ),
    );
  }
}

typedef TextColorBuilder = Color Function(ComponentContext context);

class TextColorModifier extends ComponentModifier with TextStyleModifier {
  final bool flipped;
  final Color? color;
  final TextColorBuilder? builder;

  const TextColorModifier({
    this.color,
    this.builder,
    this.flipped = false,
    super.condition,
  });

  @override
  ui.TextStyle modify(
    ui.TextStyle style,
    ComponentContext context,
  ) {
    if (color == null && builder == null) {
      final color = flipped ? context.colors.surface : context.colors.content;
      return style.copyWith(
        color: color.uiColor,
      );
    }

    if (builder != null) {
      return style.copyWith(
        color: builder!(context).uiColor,
      );
    }

    return style.copyWith(
      color: color!.uiColor,
    );
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextColorModifier) {
      return TextColorModifier(
        color: other.color,
        builder: other.builder,
      );
    }
    return this;
  }
}

mixin ModifiableTextColor<Type extends Component> on Component<Type> {
  Type defaultColor({
    bool flipped = false,
  }) {
    return withModifier(
      TextColorModifier(
        flipped: flipped,
      ),
    );
  }

  Type color(
    Color color, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextColorModifier(
        color: color,
        condition: condition,
      ),
    );
  }

  Type colorBuilder(
    TextColorBuilder builder, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextColorModifier(
        builder: builder,
        condition: condition,
      ),
    );
  }
}

class TextSizeModifier extends ComponentModifier with TextStyleModifier {
  final double size;

  const TextSizeModifier({
    required this.size,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextSizeModifier) {
      return TextSizeModifier(
        size: other.size,
      );
    }
    return this;
  }
}

mixin ModifiableTextSize<Type extends Component> on Component<Type> {
  Type size({
    required double size,
    ContextCondition? condition,
  }) {
    return withModifier(
      TextSizeModifier(
        size: size,
        condition: condition,
      ),
    );
  }
}

class FontModifier extends ComponentModifier with TextStyleModifier {
  final String? font;

  const FontModifier({
    this.font,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is FontModifier) {
      return FontModifier(
        font: other.font,
      );
    }
    return this;
  }
}

mixin ModifiableFont<Type extends Component> on Component<Type> {
  Type font(
    String font, {
    ContextCondition? condition,
  }) {
    return withModifier(
      FontModifier(
        font: font,
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

  const TextWeightModifier({
    required this.weight,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextWeightModifier) {
      return TextWeightModifier(
        weight: weight,
      );
    }
    return this;
  }
}

mixin ModifiableTextWeight<Type extends Component> on Component<Type> {
  Type weight(
    TextWeight weight, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextWeightModifier(
        weight: weight,
        condition: condition,
      ),
    );
  }
}

class TextSlantModifier extends ComponentModifier with TextStyleModifier {
  final TextSlant slant;

  const TextSlantModifier({
    required this.slant,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is TextSlantModifier) {
      return TextSlantModifier(
        slant: slant,
      );
    }
    return this;
  }
}

mixin ModifiableTextSlant<Type extends Component> on Component<Type> {
  Type slant(
    TextSlant slant, {
    ContextCondition? condition,
  }) {
    return withModifier(
      TextSlantModifier(
        slant: slant,
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

  const LetterSpacingModifier({
    required this.letterSpacing,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is LetterSpacingModifier) {
      return LetterSpacingModifier(
        letterSpacing: other.letterSpacing,
      );
    }
    return this;
  }
}

mixin ModifiableLetterSpacing<Type extends Component> on Component<Type> {
  Type letterSpacing(
    LetterSpacing letterSpacing, {
    ContextCondition? condition,
  }) {
    return withModifier(
      LetterSpacingModifier(
        letterSpacing: letterSpacing,
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

  const WordSpacingModifier({
    required this.wordSpacing,
    super.condition,
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

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is WordSpacingModifier) {
      return WordSpacingModifier(
        wordSpacing: other.wordSpacing,
      );
    }
    return this;
  }
}

mixin ModifiableWordSpacing<Type extends Component> on Component<Type> {
  Type wordSpacing(
    WordSpacing wordSpacing, {
    ContextCondition? condition,
  }) {
    return withModifier(
      WordSpacingModifier(
        wordSpacing: wordSpacing,
        condition: condition,
      ),
    );
  }
}
