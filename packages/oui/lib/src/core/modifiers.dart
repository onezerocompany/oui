import 'package:oui/oui.dart';

final allModifiers = [
  // Wrapper Modifiers
  StateModifier,
  AccentModifier,
  TypographyModifier,
  // Content Providers
  ContentProviderModifier,
  // Text Modifiers
  MaxLinesModifier,
  TextAlignModifier,
  SemanticsLabelModifier,
  SoftWrapModifier,
  TextOverflowModifier,
  TextScalerModifier,
  TextWidthModeModifier,
  TextHeightBehaviorModifier,
  SelectionColorModifier,
  // Text Style Modifiers
  TextColorModifier,
  TextSizeModifier,
  FontModifier,
  TextWeightModifier,
  TextSlantModifier,
  LetterSpacingModifier,
  WordSpacingModifier,
  // Decoration Modifiers
  ShadowModifier,
  BorderModifier,
  // Child Modifiers
  SizeModifier,
  AlignmentModifier,
  InsetModifier,
  // Child + Decoration Modifiers
  BackgroundModifier,
  CornerModifier,
];

extension ModifierSorting on ComponentModifiers {
  int _sortModifier(ComponentModifier a, ComponentModifier b) {
    final aIndex = allModifiers.indexOf(a.runtimeType);
    final bIndex = allModifiers.indexOf(b.runtimeType);

    if (aIndex == -1 || bIndex == -1) {
      return aIndex.compareTo(bIndex);
    }

    final aConditional = a.condition != null;
    final bConditional = b.condition != null;
    if (aConditional != bConditional) {
      return aConditional ? 1 : -1;
    }

    return aIndex - bIndex;
  }

  ComponentModifiers resolve(ResponsiveContext context) {
    final applicable = where(
      (modifier) => modifier.condition?.call(context) ?? true,
    ).toList();

    if (applicable.hasModifier<SizeModifier>() &&
        !applicable.hasModifier<AlignmentModifier>()) {
      applicable.add(const AlignmentModifier(Alignment.topLeft));
    }

    applicable.sort(_sortModifier);

    // get all unique types of modifiers
    final types =
        applicable.map((modifier) => modifier.runtimeType).toSet().toList();

    final resolved = <ComponentModifier>[];
    for (final type in types) {
      final modifiers = applicable.where((m) => m.runtimeType == type).toList();
      resolved.add(modifiers.reduce((a, b) => a.merge(b)));
    }
    return resolved;
  }

  bool hasModifier<Modifier extends ComponentModifier>() {
    return any((m) => m.runtimeType == Modifier);
  }
}
