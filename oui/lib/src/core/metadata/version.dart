class Version {
  final int major;
  final int minor;
  final int patch;

  const Version(
    this.major,
    this.minor,
    this.patch,
  );

  const Version.zero()
      : major = 0,
        minor = 0,
        patch = 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Version &&
        other.major == major &&
        other.minor == minor &&
        other.patch == patch;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;

  @override
  String toString() => '$major.$minor.$patch';
}
