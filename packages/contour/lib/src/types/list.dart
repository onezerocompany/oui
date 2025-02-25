import 'package:contour/src/instance.dart' show VariableInstance;
import 'package:contour/src/type.dart';

class ContourList extends ContourType<List, ContourList> {
  final ContourType item;

  const ContourList(this.item, [super.operations = const []]);

  @override
  List coerce(dynamic value) {
    if (value is List) {
      return value.map((value) => item.coerce(value)).toList();
    }
    return [item.coerce(value)];
  }

  @override
  ContourParseResult<List> parse(value, {String name = '.'}) {
    final List values = [];
    final ContourErrors errors = [];
    for (int i = 0; i < value.length; i++) {
      final itemResult = item.parse(value[i], name: '$name[$i]');
      if (itemResult.errors.isNotEmpty) {
        errors.addAll(itemResult.errors);
      } else {
        values.add(itemResult.value);
      }
    }

    final listResult = super.parse(value, name: name);
    if (listResult.errors.isNotEmpty) {
      errors.addAll(listResult.errors);
    } else {
      values.addAll(listResult.value ?? []);
    }

    return ContourParseResult<List>(values, errors);
  }

  @override
  ContourList get required => ContourList(item, [
    ...operations,
    ContourOperation.check('required', (field, value) {
      if (value == null) {
        return ContourParseResult(null, [
          ContourError(
            field: field,
            type: ContourErrorType.missing,
            message: 'Field is required',
          ),
        ]);
      }
      return ContourParseResult(value, []);
    }),
  ]);

  @override
  ContourList get optional => ContourList(item, operations);

  @override
  ContourList fallback(List value) => ContourList(item, [
    ...operations,
    ContourOperation.transform('fallback', (field, currentValue) {
      return ContourParseResult(currentValue ?? value, []);
    }),
  ]);

  @override
  VariableInstance<List> instance(String name) {
    return ListVariableInstance(this, name);
  }
}

// Added new ListVariableInstance to handle list variable instances
class ListVariableInstance extends VariableInstance<List> {
  ListVariableInstance(super.type, super.name);

  ContourErrors _errors = [];
  List? _value;

  @override
  ContourErrors get errors => _errors;

  @override
  bool get valid => _errors.isEmpty;

  @override
  List? get value => _value;

  @override
  set value(List? newValue) {
    final result = (type as ContourList).parse(newValue, name: name);
    _value = result.value;
    _errors = result.errors;
    notifySubscribers(_value);
  }
}

ContourList list(ContourType item) => ContourList(item);
