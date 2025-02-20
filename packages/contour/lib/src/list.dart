import 'package:contour/src/type.dart';

class ContourList<T> extends ContourType<List<T>> {
  final ContourType<T>? itemType;

  ContourList([this.itemType]);

  ContourList<T> min(int length, {String? message}) {
    operations.add(
      ContourCheck<List<T>>(
        check: (value) => value.length >= length,
        message: message ?? 'List must contain at least $length items',
      ),
    );
    return this;
  }

  ContourList<T> max(int length, {String? message}) {
    operations.add(
      ContourCheck<List<T>>(
        check: (value) => value.length <= length,
        message: message ?? 'List must contain at most $length items',
      ),
    );
    return this;
  }

  ContourList<T> length(int length, {String? message}) {
    operations.add(
      ContourCheck<List<T>>(
        check: (value) => value.length == length,
        message: message ?? 'List must contain exactly $length items',
      ),
    );
    return this;
  }

  ContourList<T> unique({String message = 'List must contain unique items'}) {
    operations.add(
      ContourCheck<List<T>>(
        check: (value) => value.toSet().length == value.length,
        message: message,
      ),
    );
    return this;
  }

  @override
  List<T> parse(List<T> value) {
    if (itemType != null) {
      List<ContourError> errors = [];
      final result =
          value.map((item) {
            try {
              return itemType!.parse(item);
            } catch (e) {
              if (e is ContourParseError) {
                errors.addAll(e.errors);
              } else if (e is ContourError) {
                errors.add(e);
              }
              return item;
            }
          }).toList();

      if (errors.isNotEmpty) {
        throw ContourParseError(errors);
      }
      value = result;
    }

    return super.parse(value);
  }

  ContourList<T> sort([int Function(T a, T b)? compare]) {
    operations.add(
      ContourTransformation<List<T>>((list) {
        final newList = List<T>.from(list);
        if (compare != null) {
          newList.sort(compare);
        } else {
          (newList as List).sort();
        }
        return newList;
      }),
    );
    return this;
  }

  ContourList<T> reverse() {
    operations.add(
      ContourTransformation<List<T>>((list) => list.reversed.toList()),
    );
    return this;
  }
}

ContourList<T> list<T>([ContourType<T>? itemType]) => ContourList<T>(itemType);
