/// Abstract class representing a generic generator.
abstract class Generator<T> {
  const Generator();

  /// Generates an instance of type [T].
  /// Optionally takes an input of type [I].
  T generate();
}

/// Abstract class representing a generator that requires an input.
abstract class GeneratorWithInput<T, I> {
  const GeneratorWithInput();

  /// Generates an instance of type [T] using an input of type [I].
  T generate(I input);
}
