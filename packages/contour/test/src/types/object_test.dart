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

    test('optional should remove required operation', () {
      final objectType =
          ContourObject({
            'name': ContourString(),
            'age': ContourNumber(),
          }).required.optional;
      final result = objectType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
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

    test('fallback should add a fallback operation', () {
      final objectType = ContourObject({
        'name': ContourString(),
        'age': ContourNumber(),
      }).fallback({'name': 'Default', 'age': 0});
      final result = objectType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
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

    test('should set value using bracket notation', () {
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
          'dayOfbirth': ContourObject({
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
          'dayOfbirth': {'day': 1, 'month': 1, 'year': 1990},
          'value': 30,
        },
      };
      //expect(instance['name'], {'first': 'John', 'last': 'Doe'});
      expect(instance['name']['first'], 'John');
      expect(instance['name']['last'], 'Doe');
      expect(instance['age']['dayOfbirth']['day'], 1);
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
    });
  });
}
