import 'package:flutter/foundation.dart' show nonVirtual;
import 'package:flutter/widgets.dart' show Key, Widget;
import 'package:oui/oui.dart';

abstract class Template {
  const Template();
  Component build(ComponentContext context);
  Template copyWith();
}

class TemplateComponent<T extends Template>
    extends Component<TemplateComponent<T>>
    with ModifiableInteractive<TemplateComponent<T>> {
  final T template;

  const TemplateComponent({
    super.key,
    super.modifiers,
    required this.template,
  });

  @nonVirtual
  @override
  Widget builder(ComponentContext context) {
    return template.build(context);
  }

  @override
  TemplateComponent<T> copyWith({
    Key? key,
    ComponentModifiers? modifiers,
    T? template,
  }) {
    return TemplateComponent<T>(
      key: key ?? this.key,
      modifiers: modifiers ?? this.modifiers,
      template: template ?? this.template,
    );
  }
}
