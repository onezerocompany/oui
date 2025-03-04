import 'package:contour/src/types/number.dart';
import 'package:contour/src/types/object.dart';
import 'package:contour/src/types/string.dart';
import 'package:test/test.dart';

void main() {
  group('ContourObject', () {
    test('coerce should return a map for a valid map input', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      });
      expect(objectType.coerce({'name': 'John', 'age': 30}), {
        'name': 'John',
        'age': 30,
      });
    });

    test('coerce should return null for non-map values', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      });
      expect(objectType.coerce('not a map'), isNull);
      expect(objectType.coerce(123), isNull);
    });

    test('parse should return a map for a valid map input', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      });
      final result = objectType.parse({'name': 'John', 'age': 30});
      expect(result.value, {'name': 'John', 'age': 30});
    });

    test('parse should not return non-mappable fields', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).additionalFields(false);
      final result = objectType.parse({
        'name': 'John',
        'age': 30,
        'bla': 'not a map',
      });
      expect(result.value, {'name': 'John', 'age': 30});
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.message, 'contains additional fields: bla');
    });

    test('parse should add field for non-map fields ', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).additionalFields(true);
      final result = objectType.parse({'bla': 'not a map'});
      expect(result.value, {'name': null, 'age': null, 'bla': 'not a map'});
      expect(result.errors, isEmpty);
    });

    test('optional should remove required operation', () {
      final objectType =
          ContourObject({
            'name': ContourString(),
            'age': ContourNumber(),
          }).required.optional;
      final result = objectType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('optional should validate map value', () {
      final objectType =
          ContourObject({
            'name': ContourString(),
            'age': ContourNumber(),
          }).required.optional;
      final instance = objectType.instance('test');
      instance.value = null;
      expect(instance.errors.isEmpty, isTrue);
      instance.value = {'name': 'John', 'age': 30};
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should add a required operation', () {
      final objectType =
          ContourObject({
            'name': ContourString(),
            'age': ContourNumber(),
          }).required;
      final result = objectType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('required should validate map value', () {
      final objectType =
          ContourObject({
            'name': ContourString(),
            'age': ContourNumber(),
          }).required;
      final instance = objectType.instance('test');
      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');
      instance.value = {'name': 'John', 'age': 30};
      expect(instance.errors.isEmpty, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).fallback({'name': 'Default', 'age': 0});
      final result = objectType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('fallback should validate map value', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).fallback({'name': 'Default', 'age': 0});
      final instance = objectType.instance('test');
      instance.value = null;
      expect(instance.value, {'name': 'Default', 'age': 0});
    });

    test('additionalFields should add an additionalFields operation', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).additionalFields(false);
      final result = objectType.operations.any(
        (op) => op.name == 'additionalFields',
      );
      expect(result, isTrue);
    });

    test('additionalFields should validate map value', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).additionalFields(false);
      final instance = objectType.instance('test');
      instance.value = {'name': 'John', 'age': 30};
      expect(instance.errors.isEmpty, isTrue);
      instance.value = {
        'name': 'John',
        'age': 30,
        'extra': 'field',
      }; // extra field
      expect(instance.errors.isNotEmpty, isTrue);
      expect(
        instance.errors.first.message,
        'contains additional fields: extra',
      );
    });

    test('should access value using bracket notation', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      instance['name'] = 'John';
      instance['age'] = 30;
      expect(instance['name'], 'John');
      expect(instance['age'], 30);
    });

    test('should set value using bracket notation', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      instance['name'] = 'John';
      instance['age'] = 30;
      expect(instance.value, {'name': 'John', 'age': 30});
    });

    test('should set value using bracket notation multi dimension', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      instance.value = {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': 30,
      };
      expect(instance['name']['first'], 'John');
      expect(instance['name']['last'], 'Doe');
      expect(instance['age'], 30);
    });

    test('should get value using bracket notation (recursive)', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourObject({
          'dayOfBirth': ContourObject({
            'day': ContourNumber(),
            'month': ContourNumber(),
            'year': ContourNumber(),
          }),
          'value': ContourNumber(),
        }),
      });
      final instance = objectType.instance('test');
      instance.value = {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': {
          'dayOfBirth': {'day': 1, 'month': 1, 'year': 1990},
          'value': 30,
        },
      };
      expect(instance['name']['first'], 'John');
      expect(instance['name']['last'], 'Doe');
      expect(instance['age']['dayOfBirth']['day'], 1);
    });

    test('should update value using recursive bracket notation', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      instance.value = {
        'name': {'first': 'John', 'last': 'Done'},
        'age': 30,
      };
      instance['name']['last'] = 'Doe';
      instance['age'] = 31;
      expect(instance.value, {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': 31,
      });
      instance['age'] = null;
      expect(instance.value, {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': null,
      });
    });

    test('should allow nullable variable in object', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      instance.value = {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': null,
      };
      expect(instance.value, {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': null,
      });
    });

    test('initial value should be null', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test');
      expect(instance.value, {
        'name': {'first': null, 'last': null},
        'age': null,
      });
    });

    test('initial value should be set', () {
      final objectType = ContourObject({
        'name': ContourObject({
          'first': ContourString(),
          'last': ContourString(),
        }),
        'age': ContourNumber(),
      });
      final instance = objectType.instance('test', {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': 30,
      });
      expect(instance.value, {
        'name': {'first': 'John', 'last': 'Doe'},
        'age': 30,
      });
    });
  });
}
