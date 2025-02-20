import 'package:contour/src/type.dart';

class ContourNumber extends ContourType<num> {
  ContourNumber();

  ContourNumber min(num value, {String? message}) {
    operations.add(
      ContourCheck<num>(
        check: (n) => n >= value,
        message: message ?? 'Value must be greater than or equal to $value',
      ),
    );
    return this;
  }

  ContourNumber max(num value, {String? message}) {
    operations.add(
      ContourCheck<num>(
        check: (n) => n <= value,
        message: message ?? 'Value must be less than or equal to $value',
      ),
    );
    return this;
  }

  ContourNumber positive({String message = 'Value must be positive'}) {
    operations.add(ContourCheck<num>(check: (n) => n > 0, message: message));
    return this;
  }

  ContourNumber negative({String message = 'Value must be negative'}) {
    operations.add(ContourCheck<num>(check: (n) => n < 0, message: message));
    return this;
  }

  ContourNumber integer() {
    operations.add(ContourTransformation<num>((n) => n.round()));
    return this;
  }
}

ContourNumber number() => ContourNumber();
