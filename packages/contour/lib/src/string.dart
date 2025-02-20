import 'package:contour/src/type.dart';

class ContourString extends ContourType<String> {
  ContourString();

  ContourString min(int length) {
    operations.add(
      ContourCheck<String>(
        check: (value) => value.length >= length,
        message: 'Value must be at least $length characters long',
      ),
    );
    return this;
  }

  ContourString max(int length) {
    operations.add(
      ContourCheck<String>(
        check: (value) => value.length <= length,
        message: 'Value must be at most $length characters long',
      ),
    );
    return this;
  }

  ContourString length(int length) {
    operations.add(
      ContourCheck<String>(
        check: (value) => value.length == length,
        message: 'Value must be exactly $length characters long',
      ),
    );
    return this;
  }

  ContourString pattern(RegExp pattern, {String message = 'Invalid value'}) {
    operations.add(
      ContourCheck<String>(
        check: (value) => pattern.hasMatch(value),
        message: message,
      ),
    );
    return this;
  }

  ContourString lowercase() {
    operations.add(
      ContourTransformation<String>((value) => value.toLowerCase()),
    );
    return this;
  }

  ContourString uppercase() {
    operations.add(
      ContourTransformation<String>((value) => value.toUpperCase()),
    );
    return this;
  }

  ContourString trim() {
    operations.add(ContourTransformation<String>((value) => value.trim()));
    return this;
  }

  ContourString replace(String pattern, String replacement) {
    operations.add(
      ContourTransformation<String>(
        (value) => value.replaceAll(pattern, replacement),
      ),
    );
    return this;
  }

  ContourString remove(String pattern) {
    return replace(pattern, '');
  }

  ContourString append(String value) {
    operations.add(ContourTransformation<String>((v) => v + value));
    return this;
  }

  ContourString prepend(String value) {
    operations.add(ContourTransformation<String>((v) => value + v));
    return this;
  }

  ContourString substring(int start, [int? end]) {
    operations.add(
      ContourTransformation<String>((value) {
        if (end == null) {
          return value.substring(start);
        }
        return value.substring(start, end);
      }),
    );
    return this;
  }
}

ContourString string() => ContourString();
