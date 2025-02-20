import 'package:contour/src/type.dart';

class ContourBoolean extends ContourType<bool> {
  ContourBoolean();

  ContourBoolean isTrue({String message = 'Value must be true'}) {
    operations.add(
      ContourCheck<bool>(check: (value) => value == true, message: message),
    );
    return this;
  }

  ContourBoolean isFalse({String message = 'Value must be false'}) {
    operations.add(
      ContourCheck<bool>(check: (value) => value == false, message: message),
    );
    return this;
  }
}

ContourBoolean boolean() => ContourBoolean();
