import 'interpolation.dart';
import 'utils.dart';

class TypographyConfigGroup {
  final Curve curve;
  final double minimumSize;
  final double maximumSize;
  final double minimumWeight;
  final double maximumWeight;

  const TypographyConfigGroup({
    this.curve = Curve.linear,
    this.minimumSize = 12.0,
    this.maximumSize = 24.0,
    this.minimumWeight = 300.0,
    this.maximumWeight = 500.0,
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
      minimumSize: 24.0,
      maximumSize: 48.0,
      minimumWeight: 400.0,
      maximumWeight: 700.0,
    ),
    this.subheadings = const TypographyConfigGroup(
      minimumSize: 18.0,
      maximumSize: 36.0,
      minimumWeight: 400.0,
      maximumWeight: 600.0,
    ),
    this.body = const TypographyConfigGroup(
      minimumSize: 14.0,
      maximumSize: 28.0,
      minimumWeight: 300.0,
      maximumWeight: 500.0,
    ),
    this.caption = const TypographyConfigGroup(
      minimumSize: 12.0,
      maximumSize: 24.0,
      minimumWeight: 300.0,
      maximumWeight: 400.0,
    ),
    this.footnotes = const TypographyConfigGroup(
      minimumSize: 10.0,
      maximumSize: 20.0,
      minimumWeight: 300.0,
      maximumWeight: 400.0,
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
}

class TypographyWeight {
  final double weight;

  const TypographyWeight(this.weight);
}

class TypographyGroup extends SizedContainer<TypographyStyle> {
  TypographyGroup(
    super.values,
  );
}

class TypographyStyle {
  final double size;
  final TypographyWeight weight;
  final bool italic;

  const TypographyStyle({
    this.size = 14,
    this.weight = const TypographyWeight(400),
    this.italic = false,
  });
}
