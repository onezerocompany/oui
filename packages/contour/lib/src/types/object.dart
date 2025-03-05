import 'package:contour/contour.dart';
import 'package:contour/src/types/list.dart' show ListVariableInstance;

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
      values.addAll(objectResult.value ?? {});
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
        if (currentValue != null) {
          final extraFields =
              currentValue.keys
                  .where((key) => !schema.containsKey(key))
                  .toList();
          if (extraFields.isNotEmpty) {
            if (!allow) {
              // remove extra fields
              for (final key in extraFields) {
                currentValue.remove(key);
              }
              return ContourParseResult<Map<String, dynamic>>(null, [
                ContourError(
                  field: field,
                  type: ContourErrorType.check,
                  message:
                      'contains additional fields: ${extraFields.join(', ')}',
                ),
              ]);
            } else {
              return ContourParseResult<Map<String, dynamic>>(currentValue, [
                ContourError(
                  field: field,
                  type: ContourErrorType.check,
                  message:
                      'contains additional fields: ${extraFields.join(', ')}',
                ),
              ]);
            }
          }
        }
        return ContourParseResult<Map<String, dynamic>>(currentValue, []);
      }),
    ]);
  }

  @override
  ObjectVariableInstance instance(String name, [dynamic value]) {
    return ObjectVariableInstance(this, name, value);
  }
}

ContourObject object(Map<String, ContourType> schema) =>
    ContourObject(schema).required.additionalFields(false);

class ObjectVariableInstance extends VariableInstance<Map<String, dynamic>> {
  final Map<String, VariableInstance> _instances = {};
  ContourErrors _errors = [];

  ObjectVariableInstance(super.type, super.name, [dynamic value])
    : assert(type is ContourObject) {
    for (final field in (type as ContourObject).schema.entries) {
      _instances[field.key] = field.value.instance(field.key);
      _instances[field.key]!.subscribe((_) => notifySubscribers(this.value));
    }
    if (value != null) {
      this.value = value;
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
  Map<String, dynamic> get value {
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

    // First, clear any additional field instances that might have been added previously
    final schemaKeys = (type as ContourObject).schema.keys.toSet();
    final keysToRemove =
        _instances.keys.where((k) => !schemaKeys.contains(k)).toList();
    for (final key in keysToRemove) {
      _instances.remove(key);
    }

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
      // Handle schema-defined fields
      for (final entry in _instances.entries) {
        if (valueToUse?.containsKey(entry.key) ?? false) {
          entry.value.value = valueToUse![entry.key];
        }
      }

      // Check if additional fields are allowed
      bool hasAdditionalFieldsOp = false;
      bool allowAdditionalFields = false;

      for (final op in (type as ContourObject).operations) {
        if (op.name == 'additionalFields') {
          hasAdditionalFieldsOp = true;
          // If the operation is present and the additional fields still exist in valueToUse,
          // then they are allowed
          if (valueToUse != null) {
            final additionalKeys =
                valueToUse.keys
                    .where((key) => !schemaKeys.contains(key))
                    .toList();
            allowAdditionalFields = additionalKeys.isNotEmpty;
          }
          break;
        }
      }

      // Handle additional fields if they're allowed
      if (hasAdditionalFieldsOp &&
          allowAdditionalFields &&
          valueToUse != null) {
        for (final key in valueToUse.keys) {
          if (!schemaKeys.contains(key)) {
            // Create a basic instance for this additional field
            final value = valueToUse[key];

            // Use a ContourString instance as a generic holder
            // This is a simple approach - in a real implementation, you might want to
            // detect the type and use the appropriate ContourType
            _instances[key] = ContourString().instance(key, value);
            _instances[key]!.subscribe((_) => notifySubscribers(this.value));
          }
        }
      }
    }

    notifySubscribers(value);
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

  /// Returns the instance for compound types or the value for primitive types
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
    if (instance == null) {
      // For non-schema fields, we don't add them dynamically via bracket notation
      // They should only be added through the value setter
      return;
    }
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
