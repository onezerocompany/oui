import 'package:contour/src/type.dart';

class ContourObject extends ContourType<Map<String, dynamic>> {
  final Map<String, ContourType> schema;
  final bool allowExtraFields;

  ContourObject(this.schema, {this.allowExtraFields = false});

  @override
  Map<String, dynamic> parse(Map<String, dynamic> value) {
    List<ContourError> errors = [];
    Map<String, dynamic> result = {};

    // Check for required fields and validate existing ones
    for (var entry in schema.entries) {
      final key = entry.key;
      final type = entry.value;

      if (!value.containsKey(key)) {
        errors.add(
          ContourError(
            message: 'Required field "$key" is missing',
            name: 'MissingField',
          ),
        );
        continue;
      }

      try {
        result[key] = type.parse(value[key]);
      } catch (e) {
        if (e is ContourParseError) {
          errors.addAll(
            e.errors.map(
              (error) => ContourError(
                message: '${error.message} (in field "$key")',
                name: error.name,
              ),
            ),
          );
        } else if (e is ContourError) {
          errors.add(
            ContourError(
              message: '${e.message} (in field "$key")',
              name: e.name,
            ),
          );
        }
      }
    }

    // Check for extra fields
    if (!allowExtraFields) {
      for (var key in value.keys) {
        if (!schema.containsKey(key)) {
          errors.add(
            ContourError(
              message: 'Unknown field "$key" is not allowed',
              name: 'ExtraField',
            ),
          );
        }
      }
    }

    if (errors.isNotEmpty) {
      throw ContourParseError(errors);
    }

    // Copy over any allowed extra fields
    if (allowExtraFields) {
      for (var key in value.keys) {
        if (!schema.containsKey(key)) {
          result[key] = value[key];
        }
      }
    }

    return super.parse(result);
  }

  ContourObject omit(List<String> keys) {
    final omittedSchema = Map<String, ContourType>.fromEntries(
      schema.entries.where((e) => !keys.contains(e.key)),
    );
    return ContourObject(omittedSchema, allowExtraFields: allowExtraFields);
  }

  /// Extends the current `ContourObject` with additional properties.
  ///
  /// Takes a [Map] of `String` keys and `ContourType` values as an extension.
  /// The keys represent the property names and the values represent the
  /// corresponding `ContourType` values to be added to the `ContourObject`.
  ///
  /// Returns the updated `ContourObject` with the new properties.
  ///
  /// Example:
  /// ```dart
  /// var contourObject = ContourObject();
  /// var extension = {'newProperty': ContourType.someType};
  /// contourObject.extend(extension);
  /// ```
  ///
  /// [extension]: A map containing the properties to be added.
  ContourObject extend(Map<String, ContourType> extension) {
    final extendedSchema = Map<String, ContourType>.from(schema)
      ..addAll(extension);
    return ContourObject(extendedSchema, allowExtraFields: allowExtraFields);
  }

  /// Picks a `ContourObject` from the given list of strings.
  ///
  /// The method takes a list of strings as input and returns a `ContourObject`.
  ///
  /// - Parameter list: A list of strings from which a `ContourObject` will be picked.
  /// - Returns: A `ContourObject` picked from the provided list.
  ContourObject pick(List<String> list) {
    final pickedSchema = Map<String, ContourType>.fromEntries(
      schema.entries.where((e) => list.contains(e.key)),
    );
    return ContourObject(pickedSchema, allowExtraFields: allowExtraFields);
  }
}

ContourObject object(
  Map<String, ContourType> schema, {
  bool allowExtraFields = false,
}) => ContourObject(schema, allowExtraFields: allowExtraFields);
