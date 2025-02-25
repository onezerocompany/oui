import 'package:contour/src/instance.dart' show VariableInstance;

enum ContourErrorType {
  /// Indicates that the error is related to a missing required field.
  missing,

  /// Indicates that the error is related to a type mismatch.
  type,

  /// Indicates that the error is related to a failed validation check.
  check,
}

/// Represents a single validation error that occurred during parsing.
class ContourError implements Exception {
  /// The name of the field that caused the error.
  final String field;

  /// The type of the field that caused the error.
  final ContourErrorType type;

  /// The error message describing what went wrong.
  final String message;

  const ContourError({
    required this.field,
    required this.type,
    required this.message,
  });
}

typedef ContourErrors = List<ContourError>;

class ContourParseResult<T> {
  final T? value;
  final ContourErrors errors;

  /// Creates a new [ContourParseResult].
  const ContourParseResult(this.value, this.errors);

  /// Merge two [ContourParseResult]s.
  ContourParseResult<T> merge(ContourParseResult<T> other) {
    return ContourParseResult(other.value, [...errors, ...other.errors]);
  }

  @override
  String toString() {
    return 'ContourParseResult(value: $value, errors: $errors)';
  }
}

typedef ContourOperator<T> =
    ContourParseResult<T> Function(String field, T? value);

enum ContourOperationType {
  /// Indicates that the operation is a transformation.
  transform,

  /// Indicates that the operation is a validation check.
  check,
}

/// An operation that can be performed on a value during parsing.
class ContourOperation<T> {
  /// The name of this operation.
  final String name;

  /// The type of this operation.
  final ContourOperationType type;

  /// The operator function that performs the operation.
  final ContourOperator<T> operator;

  /// Creates a new [ContourOperation].
  const ContourOperation._(this.name, this.type, this.operator);

  /// Creates a new [ContourOperation] for a transformation.
  /// The [name] is used for error reporting and debugging.
  const ContourOperation.transform(String name, ContourOperator<T> operator)
    : this._(name, ContourOperationType.transform, operator);

  /// Creates a new [ContourOperation] for a validation check.
  /// The [name] is used for error reporting and debugging.
  const ContourOperation.check(String name, ContourOperator<T> operator)
    : this._(name, ContourOperationType.check, operator);
}

/// Main class for defining type validation and transformation rules.
abstract class ContourType<T, Instance extends ContourType<T, Instance>> {
  /// List of operations to be performed during parsing.
  final List<ContourOperation<T>> operations;

  const ContourType([this.operations = const []]);

  T? coerce(dynamic value) {
    if (value is T) {
      return value;
    }
    return null;
  }

  Instance get required;
  Instance get optional;
  Instance fallback(T value);

  /// Parses a value by running it through all defined operations.
  ///
  /// Throws [ContourParseError] if any validation fails.
  ContourParseResult<T> parse(dynamic value, {String name = 'schema'}) {
    var result = ContourParseResult<T>(coerce(value), []);

    for (final op in operations.where(
      (op) => op.type == ContourOperationType.transform,
    )) {
      result = result.merge(op.operator(name, result.value));
    }

    for (final op in operations.where(
      (op) => op.type == ContourOperationType.check,
    )) {
      result = result.merge(op.operator(name, result.value));
    }

    return result;
  }

  VariableInstance<T> instance(String name);
}
