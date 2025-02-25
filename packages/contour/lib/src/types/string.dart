import 'package:contour/src/instance.dart';
import 'package:contour/src/type.dart';

class ContourString extends ContourType<String, ContourString> {
  const ContourString([super.operations = const []]);

  @override
  String? coerce(dynamic value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  ContourString equals(String value) {
    return ContourString([
      ...operations,
      ContourOperation.check('equals', (field, currentValue) {
        if (currentValue != value) {
          return ContourParseResult<String>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.check,
              message: 'should equal $value',
            ),
          ]);
        }
        return ContourParseResult<String>(value, []);
      }),
    ]);
  }

  @override
  ContourString get optional {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourString([...operations]);
  }

  @override
  ContourString get required {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourString([
      ...operations,
      ContourOperation.check('required', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<String>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.missing,
              message: 'is required',
            ),
          ]);
        }
        return ContourParseResult<String>(currentValue, []);
      }),
    ]);
  }

  @override
  ContourString fallback(String value) {
    final operations =
        this.operations.where((op) => op.name != 'fallback').toList();
    return ContourString([
      ...operations,
      ContourOperation.check('fallback', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<String>(value, []);
        }
        return ContourParseResult<String>(currentValue, []);
      }),
    ]);
  }

  ContourString oneOf(List<String> values) {
    return ContourString([
      ...operations,
      ContourOperation.check('oneOf', (field, currentValue) {
        if (!values.contains(currentValue)) {
          return ContourParseResult<String>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.check,
              message: 'should be one of ${values.join(', ')}',
            ),
          ]);
        }
        return ContourParseResult<String>(currentValue, []);
      }),
    ]);
  }

  @override
  SingleVariableInstance<String> instance(String name) {
    return SingleVariableInstance<String>(this, name);
  }
}

ContourString get string => ContourString().required;
