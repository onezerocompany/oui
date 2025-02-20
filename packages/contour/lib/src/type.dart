/// Base class for all operations that can be performed on a value during validation
/// or transformation.
abstract class ContourOperation<T> {
  const ContourOperation();
  dynamic call(T value);
}

/// Represents a single validation error that occurred during parsing.
class ContourError implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// The name or identifier of the validation that failed.
  final String name;

  const ContourError({required this.message, required this.name});

  @override
  String toString() => 'ContourValidationError: $name - $message';
}

/// Represents multiple validation errors that occurred during parsing.
class ContourParseError implements Exception {
  /// List of individual validation errors.
  final List<ContourError> errors;

  const ContourParseError(this.errors);

  @override
  String toString() {
    return 'ContourParseError: ${errors.map((e) => e.toString()).join(', ')}';
  }
}

/// A function that checks if a value meets certain criteria.
typedef ContourChecker<T> = bool Function(T value);

/// An operation that validates a value against specific criteria.
class ContourCheck<T> extends ContourOperation<T> {
  /// The function that performs the validation check.
  final ContourChecker<T> check;

  /// The error message to display if validation fails.
  final String message;

  /// The name of this validation check.
  final String name;

  const ContourCheck({required this.check, this.message = '', this.name = ''});

  @override
  T call(T value) {
    if (!check(value)) {
      throw ContourError(message: message, name: name);
    }
    return value;
  }
}

/// A function that transforms a value into another value of the same type.
typedef ContourTransformer<T> = T Function(T value);

/// An operation that transforms a value.
class ContourTransformation<T> extends ContourOperation<T> {
  /// The function that performs the transformation.
  final ContourTransformer<T> transform;

  const ContourTransformation(this.transform);

  @override
  T call(T value) {
    return transform(value);
  }
}

/// Main class for defining type validation and transformation rules.
class ContourType<T> {
  /// List of operations to be performed during parsing.
  final List<ContourOperation<T>> operations = [];

  ContourType();

  /// Adds a transformation operation to the pipeline.
  ///
  /// The transformer function will be called during parsing to modify the value.
  ContourType<T> transform(ContourTransformer<T> transformer) {
    operations.add(ContourTransformation(transformer));
    return this;
  }

  /// Adds a validation check to the pipeline.
  ///
  /// The check function will be called during parsing to validate the value.
  ContourType<T> check({
    required ContourChecker<T> check,
    String message = '',
    String name = '',
  }) {
    operations.add(ContourCheck(check: check, message: message, name: name));
    return this;
  }

  /// Parses a value by running it through all defined operations.
  ///
  /// Throws [ContourParseError] if any validation fails.
  T parse(T value) {
    T newValue = value;
    List<ContourError> errors = [];

    // First, apply all transformations in the order they were added
    for (var op in operations.where((op) => op is ContourTransformation<T>)) {
      newValue = op(newValue);
    }

    // Then, apply all checks in the order they were added, accumulating errors
    for (var op in operations.where((op) => op is ContourCheck<T>)) {
      try {
        newValue = op(newValue);
      } on ContourError catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      throw ContourParseError(errors);
    }
    return newValue;
  }
}

/// Extension method to sort a list of [ContourOperation] objects.
extension ContourOperationSorter<T> on List<ContourOperation<T>> {
  List<ContourOperation<T>> get sorted {
    return this..sort((a, b) {
      if (a is ContourTransformation && b is ContourCheck) {
        return -1;
      } else if (a is ContourCheck && b is ContourTransformation) {
        return 1;
      }
      return 0;
    });
  }
}
