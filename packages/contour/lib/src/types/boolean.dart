import 'package:contour/src/instance.dart';
import 'package:contour/src/type.dart';

class ContourBoolean extends ContourType<bool, ContourBoolean> {
  const ContourBoolean([super.operations = const []]);

  @override
  bool? coerce(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      if (value == 'true') {
        return true;
      } else if (value == 'false') {
        return false;
      }
    }
    return null;
  }

  ContourBoolean equals(bool value) {
    return ContourBoolean([
      ...operations,

      ContourOperation.check('equals', (field, currentValue) {
        if (currentValue != value) {
          return ContourParseResult<bool>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.check,
              message: 'should equal be $value',
            ),
          ]);
        }
        return ContourParseResult<bool>(value, []);
      }),
    ]);
  }

  @override
  ContourBoolean get optional {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourBoolean([...operations]);
  }

  @override
  ContourBoolean get required {
    final operations =
        this.operations.where((op) => op.name != 'required').toList();
    return ContourBoolean([
      ...operations,
      ContourOperation.check('required', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<bool>(null, [
            ContourError(
              field: field,
              type: ContourErrorType.missing,
              message: 'is required',
            ),
          ]);
        }
        return ContourParseResult<bool>(currentValue, []);
      }),
    ]);
  }

  @override
  ContourBoolean fallback(bool value) {
    return ContourBoolean([
      ...operations,
      ContourOperation.transform('fallback', (field, currentValue) {
        if (currentValue == null) {
          return ContourParseResult<bool>(value, []);
        }
        return ContourParseResult<bool>(currentValue, []);
      }),
    ]);
  }

  @override
  SingleVariableInstance<bool> instance(String name) {
    return SingleVariableInstance<bool>(this, name);
  }
}

ContourBoolean get boolean => ContourBoolean().required;
