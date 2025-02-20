import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourType', () {
    test('should transform value', () {
      final type =
          ContourType<String>()..transform((value) => value.toUpperCase());

      expect(type.parse('hello'), 'HELLO');
    });

    test('should validate value', () {
      final type =
          ContourType<String>()
            ..transform((value) => value.trim())
            ..transform((value) => value.toUpperCase())
            ..transform((value) => value + '!')
            ..transform((value) => value.substring(0, 5));

      expect(type.parse('  hello world  '), 'HELLO');
    });

    test('should throw ContourError on validation failure', () {
      final type =
          ContourType<String>()
            ..transform((value) => value.trim())
            ..transform((value) => value.toUpperCase())
            ..transform((value) => value + '!')
            ..transform((value) => value.substring(0, 5))
            ..transform((value) => value + '!')
            ..transform((value) => value.substring(0, 5))
            ..check(
              check: (value) => value.length < 5,
              message: 'Value must be less than 5 characters long',
            );

      expect(
        () => type.parse('  hello world  '),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('should throw ContourParseError with multiple errors', () {
      final type =
          ContourType<String>()
            ..check(
              check: (value) => false,
              message: 'First error',
              name: 'Err1',
            )
            ..check(
              check: (value) => false,
              message: 'Second error',
              name: 'Err2',
            );

      try {
        type.parse('anything');
      } catch (e) {
        expect(e, isA<ContourParseError>());
        final parseError = e as ContourParseError;
        expect(parseError.errors.length, 2);
      }
    });

    test('should apply validation checks', () {
      final type =
          ContourType<String>()
            ..check(
              check: (value) => value.length >= 3,
              message: 'String must be at least 3 characters',
              name: 'MinLength',
            )
            ..check(
              check: (value) => value.length <= 10,
              message: 'String must be at most 10 characters',
              name: 'MaxLength',
            );

      expect(type.parse('hello'), 'hello');
      expect(() => type.parse('hi'), throwsA(isA<ContourParseError>()));
      expect(
        () => type.parse('hello world!'),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('should combine transformations and checks', () {
      final type =
          ContourType<String>()
            ..transform((value) => value.trim())
            ..check(
              check: (value) => value.isNotEmpty,
              message: 'String cannot be empty',
              name: 'NonEmpty',
            )
            ..transform((value) => value.toUpperCase());

      expect(type.parse('  hello  '), 'HELLO');
      expect(() => type.parse('   '), throwsA(isA<ContourParseError>()));
    });
  });

  group('ContourCheck', () {
    test('should pass validation', () {
      final check = ContourCheck<String>(
        check: (value) => value.isNotEmpty,
        message: 'Value cannot be empty',
        name: 'NonEmptyCheck',
      );

      expect(check.call('hello'), 'hello');
    });

    test('should fail validation', () {
      final check = ContourCheck<String>(
        check: (value) => value.isNotEmpty,
        message: 'Value cannot be empty',
        name: 'NonEmptyCheck',
      );

      expect(() => check.call(''), throwsA(isA<ContourError>()));
    });
  });

  group('ContourTransformation', () {
    test('should transform value', () {
      final transformation = ContourTransformation<String>(
        (value) => value.toUpperCase(),
      );

      expect(transformation.call('hello'), 'HELLO');
    });
  });

  group('ContourError', () {
    test('should format toString correctly', () {
      final error = ContourError(
        message: 'Invalid value',
        name: 'ValidationTest',
      );

      expect(
        error.toString(),
        'ContourValidationError: ValidationTest - Invalid value',
      );
    });
  });

  group('ContourParseError', () {
    test('should format toString with single error', () {
      final parseError = ContourParseError([
        ContourError(message: 'Invalid value', name: 'ValidationTest'),
      ]);

      expect(
        parseError.toString(),
        'ContourParseError: ContourValidationError: ValidationTest - Invalid value',
      );
    });

    test('should format toString with multiple errors', () {
      final parseError = ContourParseError([
        ContourError(message: 'Too short', name: 'MinLength'),
        ContourError(message: 'Invalid format', name: 'Format'),
      ]);

      expect(
        parseError.toString(),
        'ContourParseError: ContourValidationError: MinLength - Too short, ContourValidationError: Format - Invalid format',
      );
    });
  });

  group('ContourType operation ordering', () {
    test('Transformation applied before validation', () {
      final type = string().uppercase().pattern(RegExp(r'^[A-Z]+$'));
      expect(type.parse('abc'), equals('ABC'));
    });

    test('Multiple validation errors accumulate', () {
      final type = string().min(5).pattern(RegExp(r'^[A-Z]+$'));
      try {
        type.parse('ab');
        fail('Expected parse error');
      } catch (e) {
        expect(e, isA<ContourParseError>());
        final errors = (e as ContourParseError).errors;
        expect(errors.length, equals(2));
      }
    });
  });
}
