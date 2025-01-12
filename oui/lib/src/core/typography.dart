import 'package:oui/src/core/utils.dart';

class Typography {}

class FontWeight {
  final double weight;

  const FontWeight(this.weight);
}

typedef TypographyGroup = SizedContainer<TypographyStyle>;

class TypographyStyle {
  final double size;
  final FontWeight weight;
  final bool italic;

  const TypographyStyle({
    this.size = 14,
    this.weight = const FontWeight(400),
    this.italic = false,
  });
}
