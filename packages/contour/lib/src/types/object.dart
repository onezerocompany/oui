import 'package:contour/src/key.dart' show VariableKey;

import '../instance.dart' show VariableInstance;
import '../type.dart'
    show
        ContourError,
        ContourErrorType,
        ContourErrors,
        ContourOperation,
        ContourParseResult,
        ContourType;

class ContourObject extends ContourType<Map<String, dynamic>, ContourObject> {
  final Map<String, ContourType> schema;

  ContourObject(this.schema, [super.operations = const []]);

  @override
  Map<String, dynamic>? coerce(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  @override
  ContourParseResult<Map<String, dynamic>> parse(value, {String name = '.'}) {
    final Map<String, dynamic> values = {};
    final ContourErrors errors = [];
    for (final entry in schema.entries) {
      final entryResult = entry.value.parse(value[entry.key], name: entry.key);
      if (entryResult.errors.isNotEmpty) {
        errors.addAll(entryResult.errors);
      } else {
        values[entry.key] = entryResult.value;
      }
    }

    final objectResult = super.parse(value, name: name);
    if (objectResult.errors.isNotEmpty) {
      errors.addAll(objectResult.errors);
    } else {
      values.addAll(objectResult.value ?? {});
    }

    return ContourParseResult<Map<String, dynamic>>(values, errors);
  }

  ContourObject additionalFields(bool allowed) {
    final operations =
        this.operations.where((op) => op.name != 'additionalFields').toList();

    return ContourObject(schema, [
      ...operations,
      ContourOperation.check('additionalFields', (field, currentValue) {
        if (currentValue != null) {
          final additionalFields =
              currentValue.keys
                  .where((key) => !schema.containsKey(key))
                  .toList();
          if (additionalFields.isNotEmpty && !allowed) {
            return ContourParseResult<Map<String, dynamic>>(null, [
              for (final field in additionalFields)
                ContourError(
                  field: field,
                  type: ContourErrorType.check,
                  message: 'additional field is not allowed: $field',
                ),
            ]);
          }
        }
        return ContourParseResult<Map<String, dynamic>>(currentValue, []);
      }),
    ]);
  }

  @override
  ContourObject get optional {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourObject(schema, [...operations]);
  }

  @override
  ContourObject get required {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourObject(schema, [
      ...operations,
      ContourOperation.check('required', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<Map<String, dynamic>>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.missing,
              message: 'is required',
            ),
          ]);
        }
        return ContourParseResult<Map<String, dynamic>>(currentValue, []);
      }),
    ]);
  }

  @override
  ContourObject fallback(Map<String, dynamic> value) {
    final operations =
        this.operations.where((op) => op.name != 'fallback').toList();
    return ContourObject(schema, [
      ...operations,
      ContourOperation.check('fallback', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<Map<String, dynamic>>(value, []);
        }
        return ContourParseResult<Map<String, dynamic>>(currentValue, []);
      }),
    ]);
  }

  @override
  ObjectVariableInstance instance(String name) {
    return ObjectVariableInstance(this, name);
  }
}

ContourObject object(Map<String, ContourType> schema) =>
    ContourObject(schema).required.additionalFields(false);

class ObjectVariableInstance extends VariableInstance<Map<String, dynamic>> {
  final Map<String, VariableInstance> _instances = {};

  ObjectVariableInstance(super.type, super.name)
    : assert(type is ContourObject) {
    for (final field in (type as ContourObject).schema.entries) {
      _instances[field.key] = field.value.instance(field.key);
      _instances[field.key]!.subscribe((_) => notifySubscribers(value));
    }
  }

  VariableInstance field(VariableKey key) {
    final (segment, next) = key.shift;
    final instance = _instances[segment.value];
    if (instance is ObjectVariableInstance && next != null) {
      return instance.field(next);
    }

    if (instance == null) {
      throw Exception("Field ${segment.value} not found");
    }

    return instance;
  }

  @override
  Map<String, dynamic>? get value {
    final result = <String, dynamic>{};
    for (final entry in _instances.entries) {
      result[entry.key] = entry.value.value;
    }
    return result;
  }

  @override
  set value(Map<String, dynamic>? value) {
    if (value == null) {
      for (final entry in _instances.entries) {
        entry.value.value = null;
      }
      return;
    }
    for (final entry in _instances.entries) {
      entry.value.value = value[entry.key];
    }
  }

  @override
  ContourErrors get errors {
    return _instances.values.fold([], (previous, element) {
      return [...previous, ...element.errors];
    });
  }

  @override
  bool get valid => errors.isEmpty;

  // Potential option
  // operator[] (VariableKey key) => field(key);
}

// class User {
//   final String name;
//   final int age;

//   User(this.name, this.age);
// }

// const user = object({
//   'name': ContourType<String>(),
//   'age': ContourType<int>(),
// }).instance("user");

// user.field("address").value = "John Doe";

// user["name"] = "John Doe";
