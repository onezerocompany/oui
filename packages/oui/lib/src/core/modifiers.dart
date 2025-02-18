import 'package:oui/src/components/box.dart' show BoxContentModifier;
import 'package:oui/src/core/background.dart' show BackgroundModifier;
import 'package:oui/src/core/border.dart' show BorderModifier;
import 'package:oui/src/core/colors.dart';
import 'package:oui/src/core/component.dart' show ComponentModifier;
import 'package:oui/src/core/corners.dart' show CornerModifier;
import 'package:oui/src/core/geometry.dart'
    show AlignmentModifier, InsetModifier, SizeModifier;
import 'package:oui/src/core/shadow.dart' show ShadowModifier;
import 'package:oui/src/core/state.dart' show StateModifier;
import 'package:oui/src/core/typography.dart'
    show
        MaxLinesModifier,
        SelectionColorModifier,
        SemanticsLabelModifier,
        SoftWrapModifier,
        TextAlignModifier,
        TextColorModifier,
        FontModifier,
        TextHeightBehaviorModifier,
        LetterSpacingModifier,
        TextOverflowModifier,
        TextScalerModifier,
        TextSizeModifier,
        TextSlantModifier,
        TextWeightModifier,
        TextWidthModeModifier,
        WordSpacingModifier;

final allModifiers = [
  BoxContentModifier,
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
  StateModifier,
  AccentModifier,
];

int sortModifier(ComponentModifier a, ComponentModifier b) {
  final aIndex = allModifiers.indexOf(a.runtimeType);
  final bIndex = allModifiers.indexOf(b.runtimeType);

  if (aIndex == -1) {
    return 1;
  }
  if (bIndex == -1) {
    return -1;
  }

  return aIndex - bIndex;
}

extension SortModifiers on List<ComponentModifier> {
  List<ComponentModifier> get sorted {
    final copy = List<ComponentModifier>.from(this);
    copy.sort(sortModifier);
    return copy;
  }

  bool hasModifier<Modifier extends ComponentModifier>() {
    return any((m) => m.runtimeType == Modifier);
  }
}
