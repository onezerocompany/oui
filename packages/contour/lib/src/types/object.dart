import 'package:contour/src/key.dart' show VariableKey;
import 'package:contour/src/types/list.dart' show ListVariableInstance;

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
    if (value == null) {
      return super.parse(value, name: name);
    }

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
      ContourOperation.transform('fallback', (field, currentValue) {
        return ContourParseResult<Map<String, dynamic>>(
          currentValue ?? value,
          [],
        );
      }),
    ]);
  }

  ContourObject additionalFields(bool allow) {
    return ContourObject(schema, [
      ...operations,
      ContourOperation.check('additionalFields', (field, currentValue) {
        if (!allow && currentValue != null) {
          final extraFields =
              currentValue.keys
                  .where((key) => !schema.containsKey(key))
                  .toList();
          if (extraFields.isNotEmpty) {
            return ContourParseResult<Map<String, dynamic>>(null, [
              ContourError(
                field: field,
                type: ContourErrorType.check,
                message:
                    'contains additional fields: ${extraFields.join(', ')}',
              ),
            ]);
          }
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
  ContourErrors _errors = [];

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
  set value(Map<String, dynamic>? inputValue) {
    final result = (type as ContourObject).parse(inputValue, name: name);
    _errors = result.errors;

    final valueToUse = result.value;

    if (inputValue == null) {
      if (valueToUse == null) {
        // If we have no fallback, set all child instances to null
        for (final entry in _instances.entries) {
          entry.value.value = null;
        }
      } else {
        // We have a fallback - set each child instance with the fallback value
        for (final entry in _instances.entries) {
          final fallbackValue = valueToUse[entry.key];
          entry.value.value = fallbackValue;
        }
      }
    } else {
      // Normal case - set values from input
      for (final entry in _instances.entries) {
        if (inputValue.containsKey(entry.key)) {
          entry.value.value = inputValue[entry.key];
        }
      }
    }

    notifySubscribers(valueToUse);
  }

  @override
  ContourErrors get errors {
    final fieldErrors = _instances.values.fold<ContourErrors>([], (
      previous,
      element,
    ) {
      return [...previous, ...element.errors];
    });

    return [..._errors, ...fieldErrors];
  }

  @override
  bool get valid => errors.isEmpty;

  /// Modified operator [] to return the instance for compound types.
  dynamic operator [](String key) {
    final instance = _instances[key];
    if (instance == null) return null;
    if (instance is ObjectVariableInstance ||
        instance is ListVariableInstance) {
      return instance;
    }
    return instance.value;
  }

  void operator []=(String key, dynamic value) {
    final instance = _instances[key];
    if (instance == null) return;
    instance.value = value;
  }

  ObjectVariableInstance? getObjectInstance(String key) {
    final instance = _instances[key];
    return instance is ObjectVariableInstance ? instance : null;
  }

  VariableInstance? getInstance(String key) {
    return _instances[key];
  }
}
