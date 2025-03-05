import 'package:flutter/cupertino.dart';

import '../core/component.dart'
    show Component, ComponentContext, ComponentModifiers;

class TextField extends Component<TextField> {
  const TextField({
    super.key,
    super.modifiers,
  });

  @override
  Widget builder(ComponentContext context) {
    return Container();
    // return EditableText(
    //   controller: controller,
    //   focusNode: FocusNode(),
    //   style: style,
    //   cursorColor: cursorColor,
    //   backgroundCursorColor: backgroundCursorColor,
    // );
  }

  @override
  TextField copyWith({ComponentModifiers? modifiers}) {
    return TextField(
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }
}
