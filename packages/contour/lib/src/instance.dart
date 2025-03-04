import 'listenable.dart' show Listenable;
import 'type.dart' show ContourErrors, ContourType;

abstract class VariableInstance<T> extends Listenable<T> {
  final ContourType type;
  final String name;

  VariableInstance(this.type, this.name);

  ContourErrors get errors;
  bool get valid;

  T? get value;
  set value(T? value);
}

/// An instance of a variable with a specific type.
class SingleVariableInstance<T> extends VariableInstance<T> {
  SingleVariableInstance(super.type, super.name, [dynamic value]) {
    this.value = value;
  }

  ContourErrors _errors = [];

  @override
  ContourErrors get errors => _errors;

  @override
  bool get valid => _errors.isEmpty;

  T? _value;

  @override
  T? get value => _value;

  @override
  set value(T? value) {
    final result = type.parse(value, name: name);
    _value = result.value;
    _errors = result.errors;
    notifySubscribers(_value);
  }
}
