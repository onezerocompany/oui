class VariableKeySegment<T> {
  final T value;
  const VariableKeySegment(this.value);
}

class VariableKey {
  final List<VariableKeySegment> segments;
  const VariableKey(this.segments);

  field(String name) =>
      VariableKey([...segments, VariableKeySegment<String>(name)]);

  index(int index) =>
      VariableKey([...segments, VariableKeySegment<int>(index)]);

  /// Returns the first segment and the rest of the key.
  (VariableKeySegment segment, VariableKey? next) get shift {
    final segment = segments.first;
    final next = segments.length > 1 ? VariableKey(segments.sublist(1)) : null;
    return (segment, next);
  }
}

const key = VariableKey([]);
