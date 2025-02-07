import 'dart:ui' as ui;

import 'interpolation.dart';
import 'utils.dart';

class TypographyConfigGroup {
  final Curve curve;
  final Range<double> size;
  final Range<double> weight;

  const TypographyConfigGroup({
    this.curve = Curve.linear,
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

  const TextStyle({
    this.size = 14,
    this.weight = const TextWeight(400),
    this.italic = TextSlant.normal,
  });
}
