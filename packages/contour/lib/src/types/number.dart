import 'package:contour/src/instance.dart';
import 'package:contour/src/type.dart';

class ContourNumber extends ContourType<num, ContourNumber> {
  const ContourNumber([super.operations = const []]);

  @override
  num? coerce(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  ContourNumber equals(num value) {
    return ContourNumber([
      ...operations,
      ContourOperation.check('equals', (field, currentValue) {
        if (currentValue != value) {
          return ContourParseResult<num>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.check,
              message: 'should equal $value',
            ),
          ]);
        }
        return ContourParseResult<num>(value, []);
      }),
    ]);
  }

  @override
  ContourNumber get optional {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourNumber([...operations]);
  }

  @override
  ContourNumber get required {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourNumber([
      ...operations,
      ContourOperation.check('required', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<num>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.missing,
              message: 'is required',
            ),
          ]);
        }
        return ContourParseResult<num>(currentValue, []);
      }),
    ]);
  }

  @override
  ContourNumber fallback(num value) {
    final operations =
        this.operations.where((op) => op.name != 'fallback').toList();
    return ContourNumber([
      ...operations,
      ContourOperation.check('fallback', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<num>(value, []);
        }
        return ContourParseResult<num>(currentValue, []);
      }),
    ]);
  }

  ContourNumber oneOf(List<num> values) {
    return ContourNumber([
      ...operations,
      ContourOperation.check('oneOf', (field, currentValue) {
        if (!values.contains(currentValue)) {
          return ContourParseResult<num>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.check,
              message: 'should be one of ${values.join(', ')}',
            ),
          ]);
        }
        return ContourParseResult<num>(currentValue, []);
      }),
    ]);
  }

  // TODO: add integer check/transform
  // TODO: add precision checks/transform
  // Are these still needed? please check number_test.dart

  @override
  SingleVariableInstance<num> instance(String name) {
    return SingleVariableInstance<num>(this, name);
  }
}

ContourNumber get number => ContourNumber().required;
