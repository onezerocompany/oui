import 'package:flutter/painting.dart'
    show
        BoxShadow,
        Color,
        DecorationImage,
        Gradient,
        ShapeBorder,
        ShapeDecoration;

extension OuiShapeDecoration on ShapeDecoration {
  ShapeDecoration copyWith({
    ShapeBorder? shape,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    Color? color,
    DecorationImage? image,
  }) {
    return ShapeDecoration(
      shape: shape ?? this.shape,
      shadows: shadows ?? this.shadows,
      gradient: gradient ?? this.gradient,
      color: color ?? this.color,
      image: image ?? this.image,
    );
  }
}

/// A generic class representing a range of values that are comparable.
///
/// The [Range] class is defined with a type parameter [T] that extends
/// [Comparable], ensuring that the values can be compared.
///
/// Example usage:
/// ```dart
/// final range = Range(1, 10);
/// print(range.within(5)); // true
/// print(range.outside(15)); // true
/// ```
///
/// [T] - The type of the values in the range, which must extend [Comparable].
///
/// Properties:
/// - `start` - The starting value of the range.
/// - `end` - The ending value of the range.
///
/// Methods:
/// - `within(T value)` - Checks if the given [value] is within the range.
/// - `outside(T value)` - Checks if the given [value] is outside the range.
/// - `toString()` - Returns a string representation of the range.
class Range<T extends Comparable> {
  final T start;
  final T end;

  const Range(
    this.start,
    this.end,
  );

  bool get isFixed => start == end;
  bool get isDynamic => !isFixed;
  bool get isUnbounded =>
      start == double.negativeInfinity && end == double.infinity;

  bool within(T value) {
    return value.compareTo(start) >= 0 && value.compareTo(end) <= 0;
  }

  bool outside(T value) {
    return !within(value);
  }

  T clamp(T value) {
    if (value.compareTo(start) < 0) {
      return start;
    } else if (value.compareTo(end) > 0) {
      return end;
    }
    return value;
  }

  /// Checks if two ranges are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Range<T>) return false;
    return start == other.start && end == other.end;
  }

  /// Returns the hash code for the range.
  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  /// Combines two ranges into a new range that spans from the minimum start to the maximum end.
  Range<T> operator +(Range<T> other) {
    final newStart = (start.compareTo(other.start) < 0) ? start : other.start;
    final newEnd = (end.compareTo(other.end) > 0) ? end : other.end;
    return Range(newStart, newEnd);
  }

  /// Subtracts one range from another, resulting in a new range.
  /// If the ranges do not overlap, returns the original range.
  Range<T>? operator -(Range<T> other) {
    if (other.end.compareTo(start) < 0 || other.start.compareTo(end) > 0) {
      return this;
    }
    final newStart = (start.compareTo(other.start) > 0) ? start : other.start;
    final newEnd = (end.compareTo(other.end) < 0) ? end : other.end;
    return (newStart.compareTo(newEnd) <= 0) ? Range(newStart, newEnd) : null;
  }

  @override
  String toString() {
    return 'Range{start: $start, end: $end}';
  }
}

abstract class EnumContainer<E extends Enum, V> {
  List<E> get keys;
  final Map<E, V> _values;

  EnumContainer(this._values) {
    if (_values.keys.toSet() != keys.toSet()) {
      throw ArgumentError('Values must be unique');
    }
  }

  EnumContainer.generate(
    V Function(E) generator,
    List<E> keys,
  ) : _values = keys.fold<Map<E, V>>(
          {},
          (map, key) => map..[key] = generator(key),
        );

  V get(E key) {
    return _values[key]!;
  }

  V operator [](E key) {
    return get(key);
  }

  @override
  int get hashCode => _values.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EnumContainer) return false;
    return _values == other._values;
  }
}

class LeveledContainer<T> {
  final int _firstLevel;
  final int _levelStep;
  final List<T> _items;

  const LeveledContainer(
    this._items, {
    int firstLevel = 0,
    int levelStep = 1,
  })  : _firstLevel = firstLevel,
        _levelStep = levelStep,
        assert(levelStep != 0);

  static const LeveledContainer<int> empty = LeveledContainer<int>([]);

  LeveledContainer.generate(
    T Function(int) generator,
    int levels, {
    int firstLevel = 0,
    int levelStep = 1,
  })  : _items = List<T>.generate(
          levels,
          (index) => generator(firstLevel + index * levelStep),
        ),
        _firstLevel = firstLevel,
        _levelStep = levelStep,
        assert(levelStep != 0);

  bool get isEmpty {
    return _items.isEmpty;
  }

  T get(int level) {
    final index = (level - _firstLevel) ~/ _levelStep;
    if (index < 0) {
      return _items.first;
    } else if (index >= _items.length) {
      return _items.last;
    }
    if (isEmpty) {
      throw StateError('LeveledContainer is empty');
    }
    return _items.elementAtOrNull(index) ?? _items.first;
  }

  T operator [](int level) {
    return get(level);
  }

  List<T> get all {
    return _items;
  }

  T get lowest {
    return _items.first;
  }

  T get highest {
    return _items.last;
  }

  List<int> get levels {
    return List<int>.generate(
      _items.length,
      (index) => _firstLevel + index * _levelStep,
    );
  }

  int get lowestLevel {
    return _firstLevel;
  }

  int get highestLevel {
    return _firstLevel + (_items.length - 1) * _levelStep;
  }

  int get levelCount {
    return _items.length;
  }

  LeveledContainer<R> map<R>(R Function(T) transform) {
    return LeveledContainer<R>(
      _items.map(transform).toList(),
      firstLevel: _firstLevel,
      levelStep: _levelStep,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      _firstLevel,
      _levelStep,
      _items,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LeveledContainer) return false;
    return _firstLevel == other._firstLevel &&
        _levelStep == other._levelStep &&
        _items == other._items;
  }

  @override
  String toString([int indent = 0]) {
    return 'LeveledContainer(\n'
        '  firstLevel: $_firstLevel,\n'
        '  levelStep: $_levelStep,\n'
        '  items: $_items\n'
        ')';
  }
}

enum SizeLevel {
  extraTiny,
  tiny,
  small,
  medium,
  large,
  huge,
  extraHuge,
}

class SizedContainer<T> extends EnumContainer<SizeLevel, T> {
  SizedContainer(super.values);

  SizedContainer.generate(
    T Function(SizeLevel) generator,
  ) : super.generate(generator, SizeLevel.values);

  @override
  List<SizeLevel> get keys => SizeLevel.values;
}
