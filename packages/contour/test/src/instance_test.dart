import 'package:contour/src/instance.dart';
import 'package:contour/src/types/string.dart';
import 'package:test/test.dart';

void main() {
  group('SingleVariableInstance', () {
    test('should initialize with no errors and null value', () {
      final instance = SingleVariableInstance(ContourString(), 'test');
      expect(instance.errors, isEmpty);
      expect(instance.valid, isTrue);
      expect(instance.value, isNull);
    });

    test('should update value and notify subscribers', () {
      final instance = SingleVariableInstance(ContourString(), 'test');
      bool notified = false;
      instance.subscribe((value) {
        notified = true;
      });
      instance.value = 'new value';
      expect(instance.value, 'new value');
      expect(instance.errors, isEmpty);
      expect(instance.valid, isTrue);
      expect(notified, isTrue);
    });

    test('should update errors and validity when value is invalid', () {
      final instance = SingleVariableInstance(
        ContourString().equals('expected'),
        'test',
      );
      instance.value = 'unexpected';
      expect(instance.value, isNull);
      expect(instance.errors, isNotEmpty);
      expect(instance.valid, isFalse);
    });
  });
}
