import 'package:contour/src/instance.dart';
import 'package:contour/src/type.dart';
import 'package:test/test.dart';

void main() {
  group('ContourType', () {
    test('should coerce value correctly', () {
      final type = TestContourType();
      expect(type.coerce(123), 123);
      expect(type.coerce('123'), null);
    });

    test('should parse value with no errors', () {
      final type = TestContourType();
      final result = type.parse(123);
      expect(result.value, 123);
      expect(result.errors, isEmpty);
    });

    test('should parse value with transformation', () {
      final type = TestContourType.withTransform();
      final result = type.parse(123);
      expect(result.value, 124);
      expect(result.errors, isEmpty);
    });

    test('should parse value with validation error', () {
      final type = TestContourType.withCheck();
      final result = type.parse(123);
      expect(result.value, 123);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.message, 'Value must be less than 100');
    });
  });
}

class TestContourType extends ContourType<int, TestContourType> {
  TestContourType() : super();

  TestContourType.withTransform()
    : super([
        ContourOperation.transform('increment', (field, value) {
          return ContourParseResult(value! + 1, []);
        }),
      ]);

  static const int _maxAllowedValue = 100;

  TestContourType.withCheck()
    : super([
        ContourOperation.check('lessThan100', (field, value) {
          if (value! >= _maxAllowedValue) {
            return ContourParseResult(value, [
              ContourError(
                field: field,
                type: ContourErrorType.check,
                message: 'Value must be less than $_maxAllowedValue',
              ),
            ]);
          }
          return ContourParseResult(value, []);
        }),
      ]);

  @override
  TestContourType get required => this;

  @override
  TestContourType get optional => this;

  @override
  TestContourType fallback(int value) => this;

  @override
  VariableInstance<int> instance(String name) {
    // Mock implementation for testing
    throw UnimplementedError();
  }
}
