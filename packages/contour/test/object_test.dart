import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourObject', () {
    test('should validate basic object structure', () {
      final type = object({
        'name': string(),
        'age': number(),
        'isStudent': boolean(),
      });

      final result = type.parse({'name': 'John', 'age': 25, 'isStudent': true});

      expect(result['name'], 'John');
      expect(result['age'], 25);
      expect(result['isStudent'], true);
    });

    test('should throw on missing required fields', () {
      final type = object({'name': string(), 'age': number()});
      expect(
        () => type.parse({'name': 'John'}),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('should handle nested validation errors', () {
      final type = object({'name': string().min(5), 'age': number().min(18)});

      try {
        type.parse({'name': 'Jon', 'age': 15});
        fail('Should have thrown');
      } catch (e) {
        expect(e, isA<ContourParseError>());
        final error = e as ContourParseError;
        expect(error.errors.length, 2);
      }
    });

    test('should handle extra fields when allowed', () {
      final type = object({'name': string()}, allowExtraFields: true);

      final result = type.parse({'name': 'John', 'extra': 'field'});

      expect(result['name'], 'John');
      expect(result['extra'], 'field');
    });

    test('should reject extra fields when not allowed', () {
      final type = object({'name': string()});

      expect(
        () => type.parse({'name': 'John', 'extra': 'field'}),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('pick() should only include specified fields', () {
      final type = object({
        'name': string(),
        'age': number(),
        'email': string(),
      }).pick(['name', 'age']);

      final result = type.parse({'name': 'John', 'age': 25});

      expect(result['name'], 'John');
      expect(result['age'], 25);
      expect(
        () => type.parse({
          'name': 'John',
          'age': 25,
          'email': 'john@example.com',
        }),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('omit() should exclude specified fields', () {
      final type = object({
        'name': string(),
        'age': number(),
        'email': string(),
      }).omit(['email']);

      final result = type.parse({'name': 'John', 'age': 25});

      expect(result['name'], 'John');
      expect(result['age'], 25);
      expect(
        () => type.parse({
          'name': 'John',
          'age': 25,
          'email': 'john@example.com',
        }),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('extend() should add new fields', () {
      final type = object({'name': string()}).extend({'age': number()});

      final result = type.parse({'name': 'John', 'age': 25});

      expect(result['name'], 'John');
      expect(result['age'], 25);
    });

    final objType = object({'name': string().min(1), 'age': number().min(0)});

    test('valid object', () {
      final result = objType.parse({'name': 'Alice', 'age': 25});
      expect(result['name'], equals('Alice'));
      expect(result['age'], equals(25));
    });

    test('missing required field', () {
      expect(
        () => objType.parse({'name': 'Alice'}),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('extra field not allowed', () {
      expect(
        () => objType.parse({'name': 'Alice', 'age': 25, 'extra': 'val'}),
        throwsA(isA<ContourParseError>()),
      );
    });

    test('extra field allowed', () {
      final allowed = object({
        'name': string().min(1),
        'age': number().min(0),
      }, allowExtraFields: true);
      final result = allowed.parse({
        'name': 'Alice',
        'age': 25,
        'extra': 'val',
      });
      expect(result['extra'], equals('val'));
    });

    test('extend schema', () {
      final base = object({'name': string()});
      final extended = base.extend({'age': number()});
      final result = extended.parse({'name': 'Bob', 'age': 30});
      expect(result['name'], equals('Bob'));
      expect(result['age'], equals(30));
    });

    test('omit field', () {
      final base = object({'name': string(), 'age': number()});
      final omitted = base.omit(['age']);
      expect(
        () => omitted.parse({'name': 'Bob', 'age': 30}),
        throwsA(isA<ContourParseError>()),
      );
      final parsed = omitted.parse({'name': 'Bob'});
      expect(parsed['name'], equals('Bob'));
    });

    test('pick fields', () {
      final base = object({
        'name': string(),
        'age': number(),
        'email': string(),
      });
      final picked = base.pick(['name', 'email']);
      final result = picked.parse({
        'name': 'Carol',
        'email': 'carol@example.com',
      });
      expect(result.containsKey('age'), isFalse);
      expect(result['name'], equals('Carol'));
    });
  });
}
