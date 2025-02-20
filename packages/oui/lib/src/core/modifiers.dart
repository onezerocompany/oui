import 'package:oui/oui.dart';

final allModifiers = [
  StateModifier,
  AccentModifier,
  ChildProviderModifier,
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
  // Child + Decoration Modifiers
  BackgroundModifier,
  CornerModifier,
  // Child Modifiers
  SizeModifier,
  AlignmentModifier,
  InsetModifier,
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
    final resolved = where(
      (modifier) => modifier.condition?.call(context) ?? true,
    ).toList();

    resolved.sort(_sortModifier);

    // get all unique types of modifiers
    final types =
        resolved.map((modifier) => modifier.runtimeType).toSet().toList();

    // remove all modifiers that are not the first of their type
    // if they have no canHaveMultiple
    for (var i = 0; i < resolved.length; i++) {
      final modifier = resolved[i];
      if (!modifier.multi &&
          types.contains(modifier.runtimeType) &&
          resolved.indexWhere((m) => m.runtimeType == modifier.runtimeType) !=
              i) {
        resolved.removeAt(i);
        i--;
      }
    }

    return resolved;
  }

  /// Groups the modifiers by type.
  List<List<ComponentModifier>> get grouped {
    final copy = List<ComponentModifier>.from(this);
    copy.sort(_sortModifier);

    final groups = <List<ComponentModifier>>[];
    var currentGroup = <ComponentModifier>[];

    for (var i = 0; i < copy.length; i++) {
      final current = copy[i];
      final next = i + 1 < copy.length ? copy[i + 1] : null;

      currentGroup.add(current);

      if (next == null || current.runtimeType != next.runtimeType) {
        groups.add(currentGroup);
        currentGroup = <ComponentModifier>[];
      }
    }

    return groups;
  }

  bool hasModifier<Modifier extends ComponentModifier>() {
    return any((m) => m.runtimeType == Modifier);
  }
}
