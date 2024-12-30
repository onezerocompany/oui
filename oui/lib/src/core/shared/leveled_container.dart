import 'generator.dart';

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

  T get(int level) {
    final index = (level - _firstLevel) ~/ _levelStep;
    if (index < 0) {
      return _items.first;
    } else if (index >= _items.length) {
      return _items.last;
    }
    return _items[index];
  }

  T operator [](int level) {
    return get(level);
  }

  T get first {
    return _items.first;
  }

  T get last {
    return _items.last;
  }

  int get levels {
    return _items.length;
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
}

class LeveledContainerGenerator<T> extends Generator<LeveledContainer<T>> {
  final T Function(int) _generator;
  final int _levels;
  final int _firstLevel;
  final int _levelStep;

  const LeveledContainerGenerator(
    this._generator,
    this._levels, {
    int firstLevel = 0,
    int levelStep = 1,
  })  : _firstLevel = firstLevel,
        _levelStep = levelStep;

  @override
  LeveledContainer<T> generate() {
    final items = List<T>.generate(
      _levels,
      (index) => _generator(_firstLevel + index * _levelStep),
    );
    return LeveledContainer(
      items,
      firstLevel: _firstLevel,
      levelStep: _levelStep,
    );
  }
}
