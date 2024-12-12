class OuiSizeRange {
  final double minimum;
  final double maximum;

  const OuiSizeRange({
    required this.minimum,
    required this.maximum,
  }) : assert(minimum <= maximum);
}
