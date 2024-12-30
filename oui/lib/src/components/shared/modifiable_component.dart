import 'package:flutter/widgets.dart';

abstract class ComponentModifierContext {
  bool didModify;
  final BuildContext context;
  final Modifiers modifiers;

  ComponentModifierContext({
    this.didModify = false,
    required this.context,
    required this.modifiers,
  });

  void modify(Function modify) {
    modify();
    didModify = true;
  }
}

/// A modifier that can modify the content and/or style of a component.
abstract class ComponentModifier<Context extends ComponentModifierContext> {
  const ComponentModifier();

  /// Modifies the content of the box.
  void modify(Context context);
}

typedef Modifiers = List<ComponentModifier>;

abstract class ModifiableComponent<M extends ComponentModifier,
    C extends ComponentModifierContext> extends StatelessWidget {
  final List<M> modifiers;

  const ModifiableComponent({
    super.key,
    required this.modifiers,
  });

  C createContext(BuildContext context);
  Widget buildWithContext(C context);

  @override
  Widget build(BuildContext context) {
    final modifiersContext = createContext(context);

    for (final modifier in modifiers) {
      modifier.modify(modifiersContext);
    }

    return buildWithContext(modifiersContext);
  }

  ModifiableComponent<M, C> copyWith({
    List<M>? modifiers,
  });

  ModifiableComponent<M, C> withModifier(M modifier, {bool replace = true}) {
    final newModifiers = List<M>.from(modifiers);

    if (replace) {
      newModifiers.removeWhere((m) => m.runtimeType == modifier.runtimeType);
    }

    newModifiers.add(modifier);
    return copyWith(
      modifiers: newModifiers,
    );
  }
}
