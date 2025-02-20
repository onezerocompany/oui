import 'package:contour/src/type.dart';

class ContourUnion<T> extends ContourType<T> {
  final List<ContourType> types;

  ContourUnion(this.types);

  @override
  T parse(T value) {
    List<ContourError> errors = [];

    for (var type in types) {
      try {
        return type.parse(value as dynamic);
      } catch (e) {
        if (e is ContourParseError) {
          errors.addAll(e.errors);
        } else if (e is ContourError) {
          errors.add(e);
        }
      }
    }

    throw ContourParseError([
      ContourError(
        message: 'Value does not match any of the expected types',
        name: 'UnionType',
      ),
      ...errors,
    ]);
  }
}

ContourUnion union(List<ContourType> types) => ContourUnion(types);
