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

class Typography {
  final TypographyGroup headings;
  final TypographyGroup subheadings;
  final TypographyGroup body;
  final TypographyGroup caption;
  final TypographyGroup footnotes;

  const Typography({
    required this.headings,
    required this.subheadings,
    required this.body,
    required this.caption,
    required this.footnotes,
  });

  factory Typography.fromConfig(TypographyConfig config) {
    return Typography(
      headings: TypographyGroup.fromConfig(config.headings),
      subheadings: TypographyGroup.fromConfig(config.subheadings),
      body: TypographyGroup.fromConfig(config.body),
      caption: TypographyGroup.fromConfig(config.caption),
      footnotes: TypographyGroup.fromConfig(config.footnotes),
    );
  }
}

class TypographyWeight {
  final double weight;

  const TypographyWeight(this.weight);
}

class TypographyGroup extends SizedContainer<TypographyStyle> {
  TypographyGroup(super.values);

  factory TypographyGroup.fromConfig(TypographyConfigGroup config) {
    final interpolator = DoubleInterpolator(curve: config.curve);
    return TypographyGroup(
      SizedContainer<TypographyStyle>.generate((size) {
        return TypographyStyle(
          size: interpolator.resolve(
            config.size.start,
            config.size.end,
            size.t,
          ),
          weight: TypographyWeight(
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

class TypographyStyle {
  final double size;
  final TypographyWeight weight;
  final double italic;

  const TypographyStyle({
    this.size = 14,
    this.weight = const TypographyWeight(400),
    this.italic = 0,
  });
}
