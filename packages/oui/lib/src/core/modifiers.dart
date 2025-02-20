import 'package:oui/oui.dart';

final allModifiers = [
  StateModifier,
  AccentModifier,
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
    final applicable = where(
      (modifier) => modifier.condition?.call(context) ?? true,
    ).toList();

    applicable.sort(_sortModifier);

    // get all unique types of modifiers
    final types =
        applicable.map((modifier) => modifier.runtimeType).toSet().toList();

    final resolved = <ComponentModifier>[];
    for (final type in types) {
      final modifiers = applicable.where((m) => m.runtimeType == type).toList();
      if (modifiers.length == 1) {
        resolved.add(modifiers.first);
      } else {
        // find the first conditional modifier and fallback to the first non conditional
        final conditional = modifiers.firstWhere(
          (m) => m.condition != null,
          orElse: () => modifiers.first,
        );
        resolved.add(conditional);
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
